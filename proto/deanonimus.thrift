include 'base.thrift'

namespace java com.rbkmoney.damsel.deanonimus
namespace erlang deanonimus

typedef base.ID PartyID
typedef i64 AccountID
typedef base.ID ContractID
typedef base.ID PayoutToolID

struct SearchHit {
    1: required double score;
    2: required Party party;
}

/** Участник. */
struct Party {
    1: required PartyID id
    2: required string email
    3: required Blocking blocking
    4: required Suspension suspension
    5: required map<ContractorID, PartyContractor> contractors
    6: required map<ContractID, Contract> contracts
    7: required map<ShopID, Shop> shops
}

/* Blocking and suspension */

union Blocking {
    1: Unblocked unblocked
    2: Blocked   blocked
}

struct Unblocked {
    1: required string reason
    2: required base.Timestamp since
}

struct Blocked {
    1: required string reason
    2: required base.Timestamp since
}

union Suspension {
    1: Active    active
    2: Suspended suspended
}

struct Active {
    1: required base.Timestamp since
}

struct Suspended {
    1: required base.Timestamp since
}

/* Common */

/** Контактная информация. **/
struct ContactInfo {
    1: optional string phone_number
    2: optional string email
}

/* Parties */
typedef i64 PartyRevision

/** Статусы участника **/
/** Данная структура используется только для получения статусов Участника **/

struct PartyStatus {
    1: required PartyID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required PartyRevision revision
}

struct PartyContactInfo {
    1: required string email
}

/* Shops */

typedef base.ID ShopID

/** Магазин мерчанта. */
struct Shop {
    1: required ShopID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required ShopDetails details
    5: required CategoryRef category
    6: optional ShopAccount account
    7: required ContractID contract_id
    8: optional PayoutToolID payout_tool_id
    9: required ShopLocation location
   10: optional BusinessScheduleRef payout_schedule
}
struct CategoryRef { 1: required base.ObjectID id }
struct BusinessScheduleRef { 1: required base.ObjectID id }

struct ShopAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement
    3: required AccountID guarantee
    /* Аккаунт на который выводятся деньги из системы */
    4: required AccountID payout
}

struct ShopDetails {
    1: required string name
    2: optional string description
}

union ShopLocation {
    1: string url
}

/* Contracts */

typedef base.ID ContractorID
typedef base.Opaque IdentityDocumentToken

struct PartyContractor {
    1: required ContractorID id
    2: required Contractor contractor
    3: required ContractorIdentificationLevel status
    4: required list<IdentityDocumentToken> identity_documents
}

/** Лицо, выступающее стороной договора. */
union Contractor {
    1: LegalEntity legal_entity
    2: RegisteredUser registered_user
}

struct RegisteredUser {
    1: required string email
}

union LegalEntity {
    1: RussianLegalEntity russian_legal_entity
    2: InternationalLegalEntity international_legal_entity
}

// TODO refactor with RepresentativePerson
/** Юридическое лицо-резидент РФ */
struct RussianLegalEntity {
    /* Наименование */
    1: required string registered_name
    /* ОГРН */
    2: required string registered_number
    /* ИНН/КПП */
    3: required string inn
    /* Адрес места нахождения */
    4: required string actual_address
    /* Адрес для отправки корреспонденции (почтовый) */
    5: required string post_address
    /* Реквизиты юр.лица */
    6: required RussianBankAccount russian_bank_account
}

struct InternationalLegalEntity {
    /* Наименование */
    1: required string legal_name
    /* Торговое наименование (если применимо) */
    2: optional string trading_name
    /* Адрес места регистрации */
    3: required string registered_address
    /* Адрес места нахождения (если отличается от регистрации)*/
    4: optional string actual_address
    /* Регистрационный номер */
    5: optional string registered_number
}

enum ContractorIdentificationLevel {
    none = 100
    partial = 200
    full = 300
}

/** Банковский счёт. */

struct RussianBankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

/** Договор */
struct Contract {
    1: required ContractID id
    2: optional ContractorID contractor_id
    3: optional base.ID payment_institution_id
    4: optional base.Timestamp valid_since
    5: optional base.Timestamp valid_until
    6: required ContractStatus status
    7: required base.ObjectID terms_id
    8: optional LegalAgreement legal_agreement
}

union RepresentativeDocument {
    1: ArticlesOfAssociation articles_of_association    // устав
    2: LegalAgreement power_of_attorney                // доверенность
}

/** Юридическое соглашение */
struct LegalAgreement {
    1: required base.Timestamp signed_at
    2: required string legal_agreement_id
    3: optional base.Timestamp valid_until
}

struct ArticlesOfAssociation {}

union ContractStatus {
    1: ContractActive active
    2: ContractTerminated terminated
    3: ContractExpired expired
}

struct ContractActive {}
struct ContractTerminated { 1: required base.Timestamp terminated_at }
struct ContractExpired {}

/** Символьный код, уникально идентифицирующий валюту. */
typedef string CurrencySymbolicCode

struct CurrencyRef { 1: required CurrencySymbolicCode symbolic_code }
