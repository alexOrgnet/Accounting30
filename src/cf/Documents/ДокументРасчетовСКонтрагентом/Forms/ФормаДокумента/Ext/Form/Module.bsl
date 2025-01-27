﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		// По документам сформированным вводом начальных остатков по НДС не допускаются изменения
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента();	
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
		УстановитьДоговорКонтрагента(ДанныеОбъекта);
		
		Объект.ДоговорКонтрагента = ДанныеОбъекта.ДоговорКонтрагента;
		Объект.ВалютаДокумента    = ДанныеОбъекта.ВалютаДокумента;
		
	Иначе
		
		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Объект.ДоговорКонтрагента = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
		КонецЕсли;	
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДатаВходящегоДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента) И НЕ Объект.Проведен Тогда
		Объект.Дата = Объект.ДатаВходящегоДокумента + (Объект.Дата - НачалоДня(Объект.Дата));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		ДанныеОбъекта = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВалютаДокумента");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
		УстановитьДоговорКонтрагента(ДанныеОбъекта);
		
		Объект.ДоговорКонтрагента = ДанныеОбъекта.ДоговорКонтрагента;
		Объект.ВалютаДокумента    = ДанныеОбъекта.ВалютаДокумента;
		
	Иначе
		
		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Объект.ДоговорКонтрагента = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
		КонецЕсли;	
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()

	Объект.ВалютаДокумента = ПолучитьВалютуДоговора(Объект.ДоговорКонтрагента);
		
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		Возврат;
	КонецЕсли;
	
	// Если не ведется учет по договорам и заполнен договор, 
	// то по реквизитам этого договора ищем основной договор
	// Если находим, то заменяем выбранный договор на основной. Учет ведется только по основным договорам.
	// В случае если не находим, то ничего не делаем, при записи документа этот договор установится как основной. 
	
	// Проверим является ли выбранный договор основным
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДоговорКонтрагента, "Организация, Владелец, ВидДоговора");
	
	ОсновнойДоговор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ОсновнойДоговор, 
		СтруктураРеквизитов.Владелец,
		СтруктураРеквизитов.Организация,
		СтруктураРеквизитов.ВидДоговора);
			
	Если ЗначениеЗаполнено(ОсновнойДоговор) И ОсновнойДоговор <> Объект.ДоговорКонтрагента Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Для расчетов с контрагентом %1 используется %2.'"), СтруктураРеквизитов.Владелец, ОсновнойДоговор);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,, "ДоговорКонтрагента");
		Объект.ДоговорКонтрагента = ОсновнойДоговор;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтаФорма, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиентеНасервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	
	Элементы = Форма.Элементы;
	
	Элементы.ДоговорКонтрагента.Доступность = ЗначениеЗаполнено(Объект.Организация) 
											и ЗначениеЗаполнено(Объект.Контрагент);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьДоговорКонтрагента(ДанныеОбъекта)

	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(ДанныеОбъекта.ДоговорКонтрагента, ДанныеОбъекта.Контрагент, ДанныеОбъекта.Организация);
	ДанныеОбъекта.ВалютаДокумента = ПолучитьВалютуДоговора(ДанныеОбъекта.ДоговорКонтрагента);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуДоговора(ДоговорКонтрагента)
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВалютаВзаиморасчетов");
	Иначе
		Возврат ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
КонецФункции

#КонецОбласти