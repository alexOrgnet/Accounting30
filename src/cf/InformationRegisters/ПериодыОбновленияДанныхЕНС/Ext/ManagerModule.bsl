﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

Функция ПолучитьДатуПоследнегоОбновления(Организация, ВидДанных = Неопределено) Экспорт
	
	ДатаПоследнегоОбновления = Дата('00010101');
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("УсловиеВидДанных", Истина);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПериодыОбновленияДанныхЕНС.ДатаОбновления) КАК ДатаОбновления,
	|	ПериодыОбновленияДанныхЕНС.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПериодыОбновленияДанныхЕНС КАК ПериодыОбновленияДанныхЕНС
	|ГДЕ
	|	ПериодыОбновленияДанныхЕНС.Организация = &Организация
	|	И &УсловиеВидДанных
	|
	|СГРУППИРОВАТЬ ПО
	|	ПериодыОбновленияДанныхЕНС.Организация";
	
	Если ВидДанных <> Неопределено Тогда
		Запрос.УстановитьПараметр("ВидДанных", ВидДанных);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеВидДанных", "ПериодыОбновленияДанныхЕНС.ВидДанных = &ВидДанных");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаПоследнегоОбновления = Выборка.ДатаОбновления;
	КонецЕсли;
	
	Возврат ДатаПоследнегоОбновления;
	
КонецФункции

Процедура УстановитьДатуПоследнегоОбновления(Организация, Период, ДатаАктуальности, ВидДанных) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ПериодыОбновленияДанныхЕНС.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация      = Организация;
	МенеджерЗаписи.ВидДанных        = ВидДанных;
	МенеджерЗаписи.ДатаОбновления   = Период;
	МенеджерЗаписи.ДатаАктуальности = ДатаАктуальности;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция ДанныеКонсистенты(Организация) Экспорт
	
	ДанныеКонсистентны = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПериодыОбновленияДанныхЕНС.ДатаОбновления) <= 1 КАК ДанныеКонсистентны
	|ИЗ
	|	РегистрСведений.ПериодыОбновленияДанныхЕНС КАК ПериодыОбновленияДанныхЕНС
	|ГДЕ
	|	ПериодыОбновленияДанныхЕНС.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	ПериодыОбновленияДанныхЕНС.Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеКонсистентны = Выборка.ДанныеКонсистентны;
	КонецЕсли;
	
	Возврат ДанныеКонсистентны;
	
КонецФункции

Функция ПолучитьДатуАктуальности(Организация, ВидДанных) Экспорт
	
	ДатаАктуальности = ЕдиныйНалоговыйСчетИнтеграцияВнутренний.ДатаНачалаЗапросовЕНС();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидДанных",   ВидДанных);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПериодыОбновленияДанныхЕНС.ДатаАктуальности КАК ДатаАктуальности
	|ИЗ
	|	РегистрСведений.ПериодыОбновленияДанныхЕНС КАК ПериодыОбновленияДанныхЕНС
	|ГДЕ
	|	ПериодыОбновленияДанныхЕНС.Организация = &Организация
	|	И ПериодыОбновленияДанныхЕНС.ВидДанных = &ВидДанных";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаАктуальности = Выборка.ДатаАктуальности;
	КонецЕсли;
	
	Возврат ДатаАктуальности;
	
КонецФункции

#КонецОбласти

#КонецЕсли