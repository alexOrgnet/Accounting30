﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ				= Параметры.Ключ;
	КонецЕсли;
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	
	ФормыДокумента = Новый ФиксированноеСоответствие(
		Документы.ВозвратТоваровПоставщику.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОперацийПоДаннымЗаполнения = ВидыОперацийПоДаннымЗаполнения(ЗначенияЗаполнения);
	ВидыОпераций = Перечисления.ВидыОперацийВозвратТоваровПоставщику.СписокДоступныхЗначений(
		ВидыОперацийПоДаннымЗаполнения);
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперацииПриОткрытии = Параметры.ВидОперации;
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(ВидОперацииПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидыОперацийПоДаннымЗаполнения(ЗначенияЗаполнения)
	
	ДоговорКонтрагента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЗначенияЗаполнения, "ДоговорКонтрагента");
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваДоговора = БухгалтерскийУчетПереопределяемый.ПолучитьРеквизитыДоговораКонтрагента(ДоговорКонтрагента);
	Возврат РаботаСДоговорамиКонтрагентовБПВызовСервера.ВидыОперацийДокумента(
		СвойстваДоговора.ВидДоговора, Тип("ДокументСсылка.ВозвратТоваровПоставщику"), Ложь);
	
КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура;
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание", Основание);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ", Ключ);
	Если ЗначениеЗаполнено("ЗначениеКопирования") Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> ВидОперацииПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ЗначениеЗаполнено(Ключ) Тогда
		КлючеваяОперация = "ОткрытиеФормыВозвратТоваровПоставщику";
	Иначе
		КлючеваяОперация = "СозданиеФормыВозвратТоваровПоставщику";
	КонецЕсли;
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	ОткрытьФорму("Документ.ВозвратТоваровПоставщику.Форма.ФормаДокументаОбщая", СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти