﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает подключенные к сервису банки.
// Функция проверяет и возвращает Неопределено, если данные регистра неактуальны.
// 
// Возвращаемое значение:
//  Неопределено, ТаблицаЗначений - см. НовыйПодключенныеБанки()
//
Функция ПодключенныеБанки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	БанкиАУСН.Банк,
		|	БанкиАУСН.Идентификатор,
		|	БанкиАУСН.СсылкаЛичныйКабинет,
		|	БанкиАУСН.ДатаИзменения
		|ИЗ
		|	РегистрСведений.БанкиАУСН КАК БанкиАУСН";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаИзменения = ТекущаяУниверсальнаяДата();
	
	ПодключенныеБанки = НовыйПодключенныеБанки();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПодключенныеБанки.Добавить(), Выборка);
		ДатаИзменения = Мин(ДатаИзменения, УниверсальноеВремя(Выборка.ДатаИзменения));
	КонецЦикла;
	
	Если ВремяАктуальностиЗаписей() < (ТекущаяУниверсальнаяДата() - ДатаИзменения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПодключенныеБанки;
	
КонецФункции

// Обновляет данные регистра
// 
// Параметры:
//  ПодключенныеБанки - ТаблицаЗначений: см. НовыйПодключенныеБанки()
//
Процедура ОбновитьСписокБанков(ПодключенныеБанки) Экспорт
	
	ПодключенныеБанки.Колонки.Добавить("ДатаИзменения", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	ПодключенныеБанки.ЗаполнитьЗначения(ТекущаяУниверсальнаяДата(), "ДатаИзменения");
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(ПодключенныеБанки);
	НаборЗаписей.Записать();
	
	РегистрыСведений.СостоянияИнтеграцииАУСН.ПодключитьФилиалы();
	
КонецПроцедуры

// Конструктор таблицы значений регистра без учета даты изменения
// 
// Возвращаемое значение:
//  ТаблицаЗначений 
//
Функция НовыйПодключенныеБанки() Экспорт
	
	ПодключенныеБанки = Новый ТаблицаЗначений();
	ПодключенныеБанки.Колонки.Добавить("Банк", Новый ОписаниеТипов("СправочникСсылка.КлассификаторБанков"));
	ПодключенныеБанки.Колонки.Добавить("Идентификатор", ОбщегоНазначения.ОписаниеТипаСтрока(36));
	ПодключенныеБанки.Колонки.Добавить("СсылкаЛичныйКабинет", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	
	Возврат ПодключенныеБанки;
	
КонецФункции

// Возвращает идентификатор банка
// 
// Параметры:
//  Банк - СправочникСсылка.КлассификаторБанков
// 
// Возвращаемое значение:
//   Строка, Неопределено - идентификатор банка
//
Функция Идентификатор(Банк) Экспорт
	
	Если Не ЗначениеЗаполнено(Банк) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Банк) = Тип("СправочникСсылка.Банки") Тогда
		Банк = РаботаСБанкамиБП.СсылкаПоКлассификатору(Банк.Код);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БанкиАУСН.Идентификатор
		|ИЗ
		|	РегистрСведений.БанкиАУСН КАК БанкиАУСН
		|ГДЕ
		|	БанкиАУСН.Банк = &Банк";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Идентификатор;
	КонецЕсли;
	
КонецФункции

// Возвращает ссылку на личный кабинет банка
// 
// Параметры:
//  Банк - СправочникСсылка.КлассификаторБанков
// 
// Возвращаемое значение:
//   Строка, Неопределено - ссылка на личный кабинет
//
Функция СсылкаЛичныйКабинет(Банк) Экспорт
	
	Если Не ЗначениеЗаполнено(Банк) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БанкиАУСН.СсылкаЛичныйКабинет
		|ИЗ
		|	РегистрСведений.БанкиАУСН КАК БанкиАУСН
		|ГДЕ
		|	БанкиАУСН.Банк = &Банк";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СсылкаЛичныйКабинет;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВремяАктуальностиЗаписей()
	
	Возврат 28800; // 8 часов
	
КонецФункции

#КонецОбласти

#КонецЕсли