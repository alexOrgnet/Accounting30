﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	// Активизировать первую непустую табличную часть
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокТабличныхЧастей.Добавить("Спецодежда",                            "Спецодежда");
	СписокТабличныхЧастей.Добавить("Спецоснастка",                          "Спецоснастка");
	СписокТабличныхЧастей.Добавить("ИнвентарьИХозяйственныеПринадлежности", "ИнвентарьИХозяйственныеПринадлежности");
	СписокТабличныхЧастей.Добавить("ВозвратнаяТара",                        "ВозвратнаяТара");
	
	АктивизироватьТабличнуюЧасть = ОбщегоНазначенияБПВызовСервера.ПолучитьПервуюНепустуюВидимуюТабличнуюЧасть(
		ЭтаФорма, СписокТабличныхЧастей);
	ОбщегоНазначенияБПВызовСервера.АктивизироватьЭлементФормы(ЭтаФорма, АктивизироватьТабличнуюЧасть);
		
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
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
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеПередачаМатериаловВЭксплуатацию";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроведениеСервер.УстановитьПризнакПроверкиРеквизитов(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
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
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	ДатаПриИзмененииНаСервере();
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпецодежда

&НаКлиенте
Процедура СпецодеждаНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецодежда.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, НазначениеИспользования, Количество,
		|СчетУчета, СчетПередачи, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ОтражатьВУСН = ПрименениеУСН И НЕ ПрименениеУСНДоходы;
	
	СпецодеждаНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецодеждаНазначениеИспользованияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецодежда.ТекущиеДанные;

	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, НазначениеИспользования, СпособОтраженияРасходов, Количество,
		|СчетУчета, СчетПередачи, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СпецодеждаНазначениеИспользованияПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецодеждаСпособОтраженияРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	// Отбирать СпособОтраженияРасходов либо по организации документа, либо по пустой организации
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Объект.Организация);
	МассивОрганизаций.Добавить(ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыФормы = Новый Структура("Отбор, ТекущаяСтрока",
		Новый Структура("Организация", МассивОрганизаций),
		Элементы.Спецодежда.ТекущиеДанные.СпособОтраженияРасходов);
	ОткрытьФорму("Справочник.СпособыОтраженияРасходовПоАмортизации.Форма.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура СпецодеждаСпособОтраженияРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ПроверкаСпособаОтраженияРасходов(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпецоснастка

&НаКлиенте
Процедура СпецоснасткаПриИзменении(Элемент)

	ОтмечатьПустоеМестонахождение = Объект.Спецоснастка.Количество() > 0;

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецоснастка.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, НазначениеИспользования, Количество,
		|СчетУчета, СчетПередачи, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ОтражатьВУСН = ПрименениеУСН И НЕ ПрименениеУСНДоходы;
	
	СпецоснасткаНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаНазначениеИспользованияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецоснастка.ТекущиеДанные;

	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, НазначениеИспользования, СпособОтраженияРасходов, Количество,
		|СчетУчета, СчетПередачи, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СпецоснасткаНазначениеИспользованияПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаСпособОтраженияРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	// Отбирать СпособОтраженияРасходов либо по организации документа, либо по пустой организации
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Объект.Организация);
	МассивОрганизаций.Добавить(ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыФормы = Новый Структура("Отбор, ТекущаяСтрока",
		Новый Структура("Организация", МассивОрганизаций),
		Элементы.Спецоснастка.ТекущиеДанные.СпособОтраженияРасходов);
	ОткрытьФорму("Справочник.СпособыОтраженияРасходовПоАмортизации.Форма.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаСпособОтраженияРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ПроверкаСпособаОтраженияРасходов(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнвентарьИХозяйственныеПринадлежности

&НаКлиенте
Процедура ИнвентарьИХозяйственныеПринадлежностиНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ИнвентарьИХозяйственныеПринадлежности.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, Количество,
		|СчетУчета, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта	= Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ОтражатьВУСН = ПрименениеУСН И НЕ ПрименениеУСНДоходы;
	
	ИнвентарьИХозяйственныеПринадлежностиНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);


КонецПроцедуры

&НаКлиенте
Процедура ИнвентарьИХозяйственныеПринадлежностиСпособОтраженияРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	// Отбирать СпособОтраженияРасходов либо по организации документа, либо по пустой организации
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Объект.Организация);
	МассивОрганизаций.Добавить(ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыФормы = Новый Структура("Отбор, ТекущаяСтрока",
		Новый Структура("Организация", МассивОрганизаций),
		Элементы.ИнвентарьИХозяйственныеПринадлежности.ТекущиеДанные.СпособОтраженияРасходов);
	ОткрытьФорму("Справочник.СпособыОтраженияРасходовПоАмортизации.Форма.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ИнвентарьИХозяйственныеПринадлежностиСпособОтраженияРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ПроверкаСпособаОтраженияРасходов(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИнвентаряНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("ИнвентарьИХозяйственныеПринадлежности"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПодборСпецодеждаНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("Спецодежда"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПодборСпецоснасткаНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("Спецоснастка"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПодборТарыНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("ВозвратнаяТара"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Местонахождение

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Местонахождение");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.Местонахождение", ВидСравненияКомпоновкиДанных.НеЗаполнено);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ОтмечатьПустоеМестонахождение", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);


	// СпецодеждаОтражениеВУСН, СпецоснасткаОтражениеВУСН, ИнвентарьИХозяйственныеПринадлежностиОтражениеВУСН

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СпецодеждаОтражениеВУСН");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СпецоснасткаОтражениеВУСН");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИнвентарьИХозяйственныеПринадлежностиОтражениеВУСН");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВозвратнаяТараОтражениеВУСН");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ПрименениеУСН", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ПрименениеУСНДоходы", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();	
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ОтмечатьПустоеМестонахождение = (Объект.Спецоснастка.Количество() > 0);
	
	ДоступнаАмортизацияСпецодежды = ТекущаяДатаДокумента < УчетМатериаловВЭксплуатации.ДатаОтменыСпецодежды();
	
	ЗаполнитьСпискиВыбораОтражениеВУСН();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ИспользоватьНазначениеИспользованияСпецодежды = ПолучитьФункциональнуюОпцию("ИспользоватьНазначениеИспользованияСпецодежды");
	
	ПрименениеУСН        = УчетнаяПолитика.ПрименяетсяУСН(Объект.Организация, Объект.Дата);
	ПрименениеУСНДоходы  = УчетнаяПолитика.ПрименяетсяУСНДоходы(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	// Доступность взаимосвязанных полей
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
	Элементы.Местонахождение.Доступность          = ЗначениеЗаполнено(Объект.Организация);
	
	Элементы.СпецодеждаСпособОтраженияРасходов.Видимость    = НЕ Форма.ДоступнаАмортизацияСпецодежды;
	Элементы.СпецоснасткаСпособОтраженияРасходов.Видимость  = НЕ Форма.ДоступнаАмортизацияСпецодежды;
	Элементы.СпецодеждаНазначениеИспользования.Видимость    = Форма.ДоступнаАмортизацияСпецодежды ИЛИ Форма.ИспользоватьНазначениеИспользованияСпецодежды;
	Элементы.СпецоснасткаНазначениеИспользования.Видимость  = Форма.ДоступнаАмортизацияСпецодежды ИЛИ Форма.ИспользоватьНазначениеИспользованияСпецодежды;
	Элементы.СпецодеждаСчетПередачи.Видимость               = Форма.ДоступнаАмортизацияСпецодежды;
	Элементы.СпецоснасткаСчетПередачи.Видимость             = Форма.ДоступнаАмортизацияСпецодежды;
	
	Элементы.СпецодеждаНазначениеИспользования.АвтоотметкаНезаполненного 	= Форма.ДоступнаАмортизацияСпецодежды;
	Элементы.СпецоснасткаНазначениеИспользования.АвтоотметкаНезаполненного 	= Форма.ДоступнаАмортизацияСпецодежды;

КонецПроцедуры

// Серверная обработка изменения реквизитов:

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ДоступнаАмортизацияСпецодежды = Объект.Дата < УчетМатериаловВЭксплуатации.ДатаОтменыСпецодежды();
	
	ЗаполнитьСпискиВыбораОтражениеВУСН(Истина);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	ЗаполнитьСпискиВыбораОтражениеВУСН(Истина);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()

	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Спецодежда" Тогда
		Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецодежда");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Спецоснастка" Тогда
		Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецоснастка");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "ИнвентарьИХозяйственныеПринадлежности" Тогда
		Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "ИнвентарьИХозяйственныеПринадлежности");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "ВозвратнаяТара");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецодеждаНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбъекта.ОтражатьВУСН Тогда
		СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.Количество = 0 Тогда
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.НазначениеИспользования) Тогда
			СтрокаТабличнойЧасти.Количество = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				СтрокаТабличнойЧасти.НазначениеИспользования, "Количество");
		КонецЕсли;
		
	КонецЕсли;
	
	Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Спецодежда", СведенияОНоменклатуре);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецодеждаНазначениеИспользованияПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
		
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.НазначениеИспользования) Тогда
		СтрокаТабличнойЧасти.Количество = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.НазначениеИспользования, "Количество");
		Если ДанныеОбъекта.Дата >= УчетМатериаловВЭксплуатации.ДатаОтменыСпецодежды() Тогда
			СтрокаТабличнойЧасти.СпособОтраженияРасходов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.НазначениеИспользования, "СпособОтраженияРасходов");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецоснасткаНазначениеИспользованияПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
		
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.НазначениеИспользования) Тогда
		СтрокаТабличнойЧасти.Количество = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.НазначениеИспользования, "Количество");
		Если ДанныеОбъекта.Дата >= УчетМатериаловВЭксплуатации.ДатаОтменыСпецодежды() Тогда
			СтрокаТабличнойЧасти.СпособОтраженияРасходов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.НазначениеИспользования, "СпособОтраженияРасходов");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецоснасткаНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбъекта.ОтражатьВУСН Тогда
		СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.Количество = 0 Тогда
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.НазначениеИспользования) Тогда
			СтрокаТабличнойЧасти.Количество = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				СтрокаТабличнойЧасти.НазначениеИспользования, "Количество");
		КонецЕсли;
		
	КонецЕсли;
	
	Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Спецоснастка", СведенияОНоменклатуре);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИнвентарьИХозяйственныеПринадлежностиНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбъекта.ОтражатьВУСН Тогда
		СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
	КонецЕсли;
	
	Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "ИнвентарьИХозяйственныеПринадлежности", СведенияОНоменклатуре);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВозвратнаяТараНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбъекта.ОтражатьВУСН Тогда
		СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
	КонецЕсли;
	
	Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "ВозвратнаяТара", СведенияОНоменклатуре);

КонецПроцедуры

// Обслуживание подбора

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(ИмяТабличнойЧасти, СтруктураОтбора)

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);

	ЗаголовокПодбора = НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	Если ИмяТаблицы = "Спецодежда" Тогда
		ПредставлениеТаблицы  = НСтр("ru = 'Спецодежда'");
	ИначеЕсли ИмяТаблицы = "Спецоснастка" Тогда
		ПредставлениеТаблицы  = НСтр("ru = 'Спецоснастка'");
	ИначеЕсли ИмяТаблицы = "ИнвентарьИХозяйственныеПринадлежности" Тогда
		ПредставлениеТаблицы  = НСтр("ru = 'Инвентарь и хозяйственные принадлежности'");
	ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
		ПредставлениеТаблицы  = НСтр("ru = 'Возвратная тара'");
	КонецЕсли;

	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокПодбора,
		Объект.Ссылка,
		ПредставлениеТаблицы);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"       , ДатаРасчетов);
	ПараметрыФормы.Вставить("Организация"        , Объект.Организация);
	ПараметрыФормы.Вставить("Склад"        		 , Объект.Склад);
	ПараметрыФормы.Вставить("Подразделение"      , Объект.ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Валюта"             , ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("ЕстьЦена"           , Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество"     , Истина);
	ПараметрыФормы.Вставить("Заголовок"          , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("СписокПодборов"     , ПолучитьСписокПодборов(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"         , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"             , Ложь);
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);

	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьСписокПодборов(ИмяТаблицы)

	// Список возможных подборов - в Обработка.ПодборНоменклатуры.Форма.Форма.УстановитьТекущийСписок(Форма)
	СписокПодборов = Новый СписокЗначений();
	СписокПодборов.Добавить("", НСтр("ru = 'По справочнику'"));
	СписокПодборов.Добавить("ОстаткиНоменклатуры", НСтр("ru = 'По остаткам'"));

	Возврат СписокПодборов;

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтруктураОтбора = Новый Структура("Номенклатура", СтрокаТовара.Номенклатура);
		СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(ИмяТаблицы, СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - увеличиваем количество.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
		Иначе
			// Не нашли - добавляем новую строку.
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			СтрокаТабличнойЧасти.Номенклатура = СтрокаТовара.Номенклатура;
			СтрокаТабличнойЧасти.Количество   = СтрокаТовара.Количество;
			
			Если ПрименениеУСН И НЕ ПрименениеУСНДоходы Тогда
				СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
			КонецЕсли;
			
			СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТовара.Номенклатура);
			
			Документы.ПередачаМатериаловВЭксплуатацию.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
				ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СчетаУчета);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Прочий функционал:

// Функция проверяет способ отражения расходов на количество строк. Если
// выбранный способ отражения расходов содержит более одной строки, возвращается
// значение Ложь, иначе - Истина.
//
// Параметр:
//  СпособОтраженияРасходов - Справочник.СпособыОтраженияРасходовПоАмортизации
// 
// Возвращаемое значение:
//  Булево.
//
Функция ПроверкаСпособаОтраженияРасходов(СпособОтраженияРасходов)
	
	КоличествоСтрок = СпособОтраженияРасходов.Способы.Количество();
	
	Если КоличествоСтрок > 1 Тогда
		
		ТекстСообщения = "Способ отражения расходов """ + СпособОтраженияРасходов + """ содержит более одной строки.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции // ПроверкаСпособаОтраженияРасходов()

Процедура ЗаполнитьСпискиВыбораОтражениеВУСН(ПерезаполнитьНедоступныеЗначения = Ложь)
	
	Если Не (ПрименениеУСН И Не ПрименениеУСНДоходы) Тогда
		Возврат;
	КонецЕсли;
	
	ПрименяетсяОсобыйНалоговыйРежим = УчетнаяПолитика.ПрименяетсяУСНПатент(Объект.Организация, Объект.Дата)
		Или УчетнаяПолитика.ПлательщикЕНВД(Объект.Организация, Объект.Дата);
	
	ДоступныеОтражения = Перечисления.ОтражениеВУСН.СписокВыбора(ПрименяетсяОсобыйНалоговыйРежим, Истина);
	
	ИменаТабличныхЧастей = Новый Массив;
	ИменаТабличныхЧастей.Добавить("Спецодежда");
	ИменаТабличныхЧастей.Добавить("Спецоснастка");
	ИменаТабличныхЧастей.Добавить("ИнвентарьИХозяйственныеПринадлежности");
	ИменаТабличныхЧастей.Добавить("ВозвратнаяТара");
	
	Для Каждого ИмяТаблицы Из ИменаТабличныхЧастей Цикл
		НастраиваемыйЭлемент = Элементы[ИмяТаблицы + "ОтражениеВУСН"];
		СписокВыбора = НастраиваемыйЭлемент.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ЭлементОтражения Из ДоступныеОтражения Цикл
			СписокВыбора.Добавить(ЭлементОтражения.Значение, ЭлементОтражения.Представление);
		КонецЦикла;
	КонецЦикла;
	
	Если ПерезаполнитьНедоступныеЗначения Тогда
		
		Для Каждого ИмяТаблицы Из ИменаТабличныхЧастей Цикл
			Для Каждого СтрокаТаблицы Из Объект[ИмяТаблицы] Цикл
				Если ДоступныеОтражения.НайтиПоЗначению(СтрокаТаблицы.ОтражениевУСН) = Неопределено Тогда
					СтрокаТаблицы.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыВозвратнаяТара

&НаКлиенте
Процедура ВозвратнаяТараСпособОтраженияРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	// Отбирать СпособОтраженияРасходов либо по организации документа, либо по пустой организации
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Объект.Организация);
	МассивОрганизаций.Добавить(ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыФормы = Новый Структура("Отбор, ТекущаяСтрока",
		Новый Структура("Организация", МассивОрганизаций),
		Элементы.ВозвратнаяТара.ТекущиеДанные.СпособОтраженияРасходов);
	ОткрытьФорму("Справочник.СпособыОтраженияРасходовПоАмортизации.Форма.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараСпособОтраженияРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ПроверкаСпособаОтраженияРасходов(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВозвратнаяТара.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, Количество,
		|СчетУчета, ОтражениеВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта	= Новый Структура(
		"Дата, Организация, Склад, ОтражатьВУСН");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ОтражатьВУСН = ПрименениеУСН И НЕ ПрименениеУСНДоходы;
	
	ВозвратнаяТараНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

#КонецОбласти
