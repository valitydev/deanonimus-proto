include 'base.thrift'

namespace java dev.vality.damsel.deanonimus
namespace erlang deanonimus

typedef base.ID PartyID
typedef i64 AccountID
typedef base.ID ContractID

struct SearchHit {
    1: required double score;
    2: required Party party;
}

struct SearchShopHit {
    1: required double score;
    2: required Shop shop;
    3: required Party party;
}

struct SearchWalletHit {
    1: required double score;
    2: required Wallet wallet;
    3: required Party party;
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
    8: optional map<WalletID, Wallet> wallets
}

/* Blocking and suspension */

union Blocking {
    1: Unblocked unblocked
    2: Blocked   blocked
}

struct Unblocked {}
struct Blocked {}

union Suspension {
    1: Active    active
    2: Suspended suspended
}

struct Active {}
struct Suspended {}

/* Wallets */

typedef base.ID WalletID

struct Wallet {
    1: required WalletID id
    2: required string name
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
    9: required ShopLocation location
}
struct CategoryRef { 1: required base.ObjectID id }

struct ShopAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement
    3: required AccountID guarantee
    /* Аккаунт на который выводятся деньги из системы */
    // deprecated
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

struct PartyContractor {
    1: required ContractorID id
    2: required Contractor contractor
}

/** Лицо, выступающее стороной договора. */
union Contractor {
    1: LegalEntity legal_entity
    2: RegisteredUser registered_user
    3: PrivateEntity private_entity
}

struct RegisteredUser {
    1: required string email
}

union LegalEntity {
    1: RussianLegalEntity russian_legal_entity
    2: InternationalLegalEntity international_legal_entity
}

struct PrivateEntity {}

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
    3: optional base.ObjectID payment_institution_id
    4: optional base.Timestamp valid_since
    5: optional base.Timestamp valid_until
    6: required ContractStatus status
    7: required base.ObjectID terms_id
    8: optional LegalAgreement legal_agreement
}

union RepresentativeDocument {
    // устав
    1: ArticlesOfAssociation articles_of_association
    // доверенность
    2: LegalAgreement power_of_attorney
}

/** Юридическое соглашение */
struct LegalAgreement {
    1: required base.ID id
}

struct ArticlesOfAssociation {}

union ContractStatus {
    1: ContractActive active
    2: ContractTerminated terminated
    3: ContractExpired expired
}

struct ContractActive {}
struct ContractTerminated {}
struct ContractExpired {}

struct CurrencyRef { 1: required base.CurrencySymbolicCode symbolic_code }

service Deanonimus {
    list<SearchHit> searchParty(1: string text)

    list<SearchShopHit> searchShopText(1: string text)

    list<SearchWalletHit> searchWalletText(1: string text)
}
