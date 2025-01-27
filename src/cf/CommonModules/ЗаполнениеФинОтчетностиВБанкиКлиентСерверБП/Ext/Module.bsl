﻿#Область ПрограммныйИнтерфейс

// Сопоставляет для указанного вида отчета соответствующий ему источник (способ) заполнения.
//
// Параметры:
//  ВидОтчета    - Строка - см. колонку из результата ЗаполнениеФинОтчетностиВБанки.ОписаниеВидовОтчетов()
//
// Возвращаемое значение:
//  Строка, Неопределено - принимает значения: ОтчетБРО, СтандартныйОтчет, ВнешнийФайл, ПроизвольныйФайл.
//
Функция ОпределитьСпособЗаполненияВидаОтчета(ВидОтчета) Экспорт
	Перем СпособЗаполнения;

	Если ВидОтчета = "СправкаБанка"
	 Или ВидОтчета = "СправкаФНСОбИсполненииОбязанностейПоУплатеНалогов"
	 Или ВидОтчета = "СправкаФНСОбОткрытыхРасчетныхСчетах"
	 Или ВидОтчета = "БухгалтерскаяОтчетностьАудиторскоеЗаключение"
	 Или ВидОтчета = "БухгалтерскаяОтчетностьПояснения"
	 Или ВидОтчета = "Патент" Тогда
		СпособЗаполнения = "ВнешнийФайл";

	ИначеЕсли ВидОтчета = "КарточкаСчета"
	 Или ВидОтчета = "АнализСчета"
	 Или ВидОтчета = "ОборотноСальдоваяВедомость"
	 Или ВидОтчета = "ОборотноСальдоваяВедомостьПоСчету"
	 Или ВидОтчета = "ОборотыСчета"
	 Или ВидОтчета = "ВедомостьАмортизацииОС"
	 Или ВидОтчета = "ВаловаяПрибыль"
	 Или ВидОтчета = "ОстаткиТоваровПоСрокамХранения"
	 Или ВидОтчета = "РасшифровкаЗадолженности"
	 Или ВидОтчета = "КнигаУчетаДоходовИРасходов"
	 Или ВидОтчета = "КнигаУчетаДоходовИРасходовПредпринимателя"
	 Или ВидОтчета = "КнигаУчетаДоходовПатент"
	 Или ВидОтчета = "КассоваяКнига" Тогда
		СпособЗаполнения = "СтандартныйОтчет";

	ИначеЕсли ВидОтчета = "БухгалтерскаяОтчетность"
	 Или ВидОтчета = "ДекларацияПрибыль"
	 Или ВидОтчета = "ДекларацияНДС"
	 Или ВидОтчета = "ДекларацияУСН"
	 Или ВидОтчета = "ДекларацияЕНВД"
	 Или ВидОтчета = "ДекларацияИмущество"
	 Или ВидОтчета = "Декларация3НДФЛ"
	 Или ВидОтчета = "ДекларацияЕСХН"
	 Или ВидОтчета = "РасчетПоСтраховымВзносам" Тогда
		СпособЗаполнения = "ОтчетБРО";

	ИначеЕсли ВидОтчета = "ОтчетПоФормеБанка" Тогда 
		СпособЗаполнения = "ОтчетПоФормеБанка";

	КонецЕсли;
	
	Возврат СпособЗаполнения;
	
КонецФункции

#КонецОбласти
