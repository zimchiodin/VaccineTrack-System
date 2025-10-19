;; Infant Vaccination Tracker Contract
;; Manages immunization records for newborns and infants

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u400))
(define-constant err-not-found (err u401))
(define-constant err-unauthorized (err u402))
(define-constant err-invalid-data (err u403))
(define-constant err-duplicate (err u404))

(define-map healthcare-providers principal bool)
(define-map infant-profiles
  principal
  {
    infant-name: (string-ascii 50),
    date-of-birth: uint,
    parent-principal: principal,
    registered-by: principal,
    registered-at: uint
  }
)

(define-map vaccination-records
  { infant: principal, vaccine-id: uint }
  {
    vaccine-name: (string-ascii 50),
    vaccine-type: (string-ascii 30),
    dose-number: uint,
    administration-date: uint,
    administered-by: principal,
    batch-number: (string-ascii 30),
    next-dose-date: uint,
    site-of-injection: (string-ascii 20),
    adverse-reactions: (string-ascii 200)
  }
)

(define-map infant-vaccine-count principal uint)

;; Authorize healthcare provider
(define-public (authorize-provider (provider principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set healthcare-providers provider true))
  )
)

;; Register infant profile
(define-public (register-infant
  (infant-principal principal)
  (infant-name (string-ascii 50))
  (date-of-birth uint)
  (parent-principal principal))
  (begin
    (asserts! (default-to false (map-get? healthcare-providers tx-sender)) err-unauthorized)
    (asserts! (is-none (map-get? infant-profiles infant-principal)) err-duplicate)
    (map-set infant-profiles
      infant-principal
      {
        infant-name: infant-name,
        date-of-birth: date-of-birth,
        parent-principal: parent-principal,
        registered-by: tx-sender,
        registered-at: stacks-block-height
      }
    )
    (ok true)
  )
)

;; Record vaccination
(define-public (record-vaccination
  (infant principal)
  (vaccine-name (string-ascii 50))
  (vaccine-type (string-ascii 30))
  (dose-number uint)
  (batch-number (string-ascii 30))
  (next-dose-date uint)
  (site-of-injection (string-ascii 20))
  (adverse-reactions (string-ascii 200)))
  (let ((vaccine-count (default-to u0 (map-get? infant-vaccine-count infant)))
        (new-vaccine-id (+ vaccine-count u1)))
    (asserts! (default-to false (map-get? healthcare-providers tx-sender)) err-unauthorized)
    (asserts! (is-some (map-get? infant-profiles infant)) err-not-found)
    (map-set vaccination-records
      {infant: infant, vaccine-id: new-vaccine-id}
      {
        vaccine-name: vaccine-name,
        vaccine-type: vaccine-type,
        dose-number: dose-number,
        administration-date: stacks-block-height,
        administered-by: tx-sender,
        batch-number: batch-number,
        next-dose-date: next-dose-date,
        site-of-injection: site-of-injection,
        adverse-reactions: adverse-reactions
      }
    )
    (map-set infant-vaccine-count infant new-vaccine-id)
    (ok new-vaccine-id)
  )
)

;; Get infant profile
(define-read-only (get-infant-profile (infant principal))
  (map-get? infant-profiles infant)
)

;; Get vaccination record
(define-read-only (get-vaccination-record (infant principal) (vaccine-id uint))
  (map-get? vaccination-records {infant: infant, vaccine-id: vaccine-id})
)

;; Get total vaccinations for infant
(define-read-only (get-vaccination-count (infant principal))
  (default-to u0 (map-get? infant-vaccine-count infant))
)

;; Check if provider is authorized
(define-read-only (is-authorized-provider (provider principal))
  (default-to false (map-get? healthcare-providers provider))
)

;; Get latest vaccination
(define-read-only (get-latest-vaccination (infant principal))
  (let ((vaccine-count (default-to u0 (map-get? infant-vaccine-count infant))))
    (if (> vaccine-count u0)
      (map-get? vaccination-records {infant: infant, vaccine-id: vaccine-count})
      none
    )
  )
)

;; Get next dose date
(define-read-only (get-next-dose-date (infant principal))
  (match (get-latest-vaccination infant)
    record (some (get next-dose-date record))
    none
  )
)

;; Check for adverse reactions history
(define-read-only (has-adverse-reactions (infant principal))
  (match (get-latest-vaccination infant)
    record (> (len (get adverse-reactions record)) u0)
    false
  )
)