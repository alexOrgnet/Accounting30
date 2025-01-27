﻿
#Область ПроцедурыИФункцииОбщегоНазначения

#Область ОбщегоНазначения

&НаСервереБезКонтекста
Функция ПеречитатьДатуНачалаУчета(Организация)
	
	Возврат Обработки.ВводНачальныхОстатков.ПеречитатьДатуНачалаУчета(Организация);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Ложь;
		ЗаписатьНаСервере(, Отказ);
		Если НЕ Отказ Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоляСтрокиТабличнойЧасти(СтрокаТаблицы)
	
	КолонкиТаблицы = СтруктураТаблиц.Получить(0).Значение;
	
	ПараметрыСтроки  = Новый Структура("Организация, ДатаВводаОстатков, ВалютаРегламентированногоУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Объект.ВалютаРегламентированногоУчета);
	
	Для Каждого Колонка ИЗ КолонкиТаблицы Цикл
		ИмяКолонки = Колонка.Значение;
		ПараметрыСтроки.Вставить(ИмяКолонки, СтрокаТаблицы[ИмяКолонки]);
	КонецЦикла;
	
	Возврат ПараметрыСтроки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита)
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
	КонецЕсли;
	Обработки.ВводНачальныхОстатков.ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, "ВалютнаяСумма");
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина, Отказ = Ложь)
	
	Отказ = НЕ ПроверитьЗаполнение();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.Подотчет, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.РасчетыСПодотчетнымиЛицами);
	
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "Подотчет");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.Подотчет, Отбор);
	
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.Подотчет);
	
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "РасчетыСПодотчетнымиЛицами");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.Подотчет, "Подотчет", 
			Новый Структура("Организация,ДатаВводаОстатков",
				Объект.Организация,Объект.ДатаВводаОстатков),
			Объект.СуществующиеДокументы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличнуюЧастьКЗаписи(Таблица);
	
	ТаблицаДанных = Таблица.Выгрузить();
	
	ТаблицаДанных.Колонки.Задолженность.Имя = "Сумма";
	ТаблицаДанных.Колонки.Перерасход.Имя    = "СуммаКт";
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОбработчикиЭлементовШапкиФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Модифицированность Тогда
		НомерСтроки = 0;
		Если Элементы.Подотчет.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.Подотчет.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		Отказ = Ложь;
		ЗаписатьНаСервере(Истина, Отказ);
		Если НЕ Отказ Тогда
			Если НомерСтроки <> 0 Тогда
				Элементы.Подотчет.ТекущаяСтрока = Объект.Подотчет[НомерСтроки-1].ПолучитьИдентификатор();
			КонецЕсли;
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	Если Модифицированность Тогда
		ЗаписатьНаСервере(Ложь, Отказ);
		Если НЕ Отказ Тогда
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура ПересчитатьЗадолженностьИлиАванс(ИмяРеквизита, ИмяОбнуляемогоРеквизита)
	
	СтрокаТаблицы   = Элементы.Подотчет.ТекущиеДанные;
	
	СтрокаТаблицы[ИмяОбнуляемогоРеквизита] = 0;
	СтрокаТаблицы[ИмяОбнуляемогоРеквизита + "Остаток"] = 0;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетВалютаПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.Подотчет.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПараметрыСтроки.СчетУчета = "";
	Если НЕ ЗначениеЗаполнено(ПараметрыСтроки.Валюта) Тогда
		ПараметрыСтроки.Валюта = Объект.ВалютаРегламентированногоУчета;
	КонецЕсли;
	ВалютаПриИзмененииСервер(ПараметрыСтроки, ?(СтрокаТаблицы.Задолженность <> 0, "Задолженность", "Перерасход"));
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетЗадолженностьОстатокПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиАванс("Задолженность", "Перерасход");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетПерерасходОстатокПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиАванс("Перерасход", "Задолженность");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы   = Элементы.Подотчет.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Валюта) Тогда
		СтрокаТаблицы.Валюта = Объект.ВалютаРегламентированногоУчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетВалютаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Подотчет (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	ЭтаФорма.Заголовок = ТекстЗаголовок;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.Подотчет, "Подотчет", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.Подотчет, "Подотчет", 
		Новый Структура("Организация,ДатаВводаОстатков",
					Объект.Организация,Объект.ДатаВводаОстатков),
		Объект.СуществующиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененениеДатыВводаОстатков" И Источник = "ВводНачальныхОстатков" И Параметр = Объект.Организация Тогда
		Объект.ДатаВводаОстатков = ПеречитатьДатуНачалаУчета(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПередЗакрытиемЗавершение",
		ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти
