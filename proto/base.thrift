namespace java com.rbkmoney.damsel.deanonimus.base
namespace erlang base

/** Символьный код, уникально идентифицирующий валюту. */
typedef string CurrencySymbolicCode

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp

/** Идентификатор */
typedef string ID
typedef i32 ObjectID