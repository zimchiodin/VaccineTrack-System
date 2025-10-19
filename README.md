# VaccineTrack - Infant Immunization Record System

A blockchain-based immunization tracking system for infants and newborns, ensuring secure and verifiable vaccination records on the Stacks network.

## Features

- **Complete Immunization History**: Track all vaccinations from birth
- **Batch Number Recording**: Enable vaccine traceability for safety recalls
- **Adverse Reaction Monitoring**: Document and track any vaccine reactions
- **Dose Scheduling**: Automatic tracking of next dose due dates
- **Provider Authentication**: Only authorized healthcare providers can record vaccinations
- **Parent Linkage**: Connect infant records to parent principals

## Vaccination Data Captured

- Vaccine name and type
- Dose number and administration date
- Batch number for traceability
- Injection site and administering provider
- Adverse reactions documentation
- Next dose scheduling

## Contract Functions

### Public Functions
- `authorize-provider(provider)` - Authorize healthcare provider (owner only)
- `register-infant(...)` - Register new infant profile (providers only)
- `record-vaccination(...)` - Record new vaccination (providers only)

### Read-Only Functions
- `get-infant-profile(infant)` - Retrieve infant profile information
- `get-vaccination-record(infant, vaccine-id)` - Get specific vaccination record
- `get-vaccination-count(infant)` - Get total number of vaccinations
- `is-authorized-provider(provider)` - Check provider authorization
- `get-latest-vaccination(infant)` - Get most recent vaccination
- `get-next-dose-date(infant)` - Get scheduled next dose date
- `has-adverse-reactions(infant)` - Check if infant has reaction history

## Usage

1. Deploy contract and authorize healthcare providers
2. Providers register infant profiles with parent linkage
3. Record vaccinations during well-baby visits
4. Track immunization schedules and completion
5. Monitor for adverse reactions across vaccine history

## Safety Features

- Batch number tracking for recall management
- Adverse reaction documentation
- Complete immunization history
- Provider accountability through blockchain records

## License

MIT License