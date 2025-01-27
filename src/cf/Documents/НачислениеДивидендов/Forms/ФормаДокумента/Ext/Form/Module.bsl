﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Объект.РасчетныйПериод = КонецКвартала(НачалоКвартала(Объект.Дата)-1);
			УстановитьПланируемуюДатуВыплаты(ЭтотОбъект);
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	Элементы.ФормаВыплатить.Доступность = ЭтотОбъект.Доступность И НЕ ЭтотОбъект.ТолькоПросмотр;
	
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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроведениеСервер.УстановитьПризнакПроверкиРеквизитов(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_НачислениеДивидендов", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовШапки

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУчредителяПриИзменении(Элемент)
	
	ТипУчредителяПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУчредителяОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УчредительПриИзменении(Элемент)
	
	УчредительПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаПриИзменении(Элемент)
	
	СуммаДоходаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогаПриИзменении(Элемент)
	
	ОбновитьОписаниУдержанийВыплат(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачисленияСтрокойПриИзменении(Элемент)
	
	ПериодНачисленияСтрокой = ПредставлениеПериода(НачалоГода(Объект.РасчетныйПериод),
								КонецКвартала(Объект.РасчетныйПериод),
								"ФП = Истина");
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода, НарастающимИтогом", НачалоГода(Объект.РасчетныйПериод), КонецКвартала(Объект.РасчетныйПериод), Истина);
	ОписаниеОповещения     = Новый ОписаниеОповещения("ПериодНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКварталНарастающимИтогом", ПараметрыВыбораПериода, Элементы.ПериодНачисленияСтрокой, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогаИтогНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ КлючевыеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("РедактированиеНалогаЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресПараметровВХранилище", АдресПараметровВХранилище());
	ПараметрыОткрытия.Вставить("ТолькоПросмотр",            ТолькоПросмотр ИЛИ УчетЗарплатыИКадровСредствамиБухгалтерии);
	
	ОткрытьФорму("Документ.НачислениеДивидендов.Форма.ФормаНДФЛ", 
		ПараметрыОткрытия,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланируемаяДатаВыплатыПриИзменении(Элемент)
	
	ПланируемаяДатаВыплатыПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выплатить(Команда)
	
	Если НЕ Объект.ПометкаУдаления И НЕ Объект.Проведен ИЛИ Модифицированность Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Вставить(0, КодВозвратаДиалога.Да,     "Провести");
		Кнопки.Вставить(1, КодВозвратаДиалога.Отмена, "Отмена");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередВыплатойСледуетПровестиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед выплатой документ следует провести'"), Кнопки,, КодВозвратаДиалога.Да);
	Иначе
		СформироватьДокументыВыплаты();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПланируемуюДатуВыплаты(Форма)
	
	Объект = Форма.Объект;
	Если Форма.УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		Объект.ПланируемаяДатаВыплаты = Объект.Дата + 60*86400; // 60 дней.
	Иначе
		Объект.ПланируемаяДатаВыплаты = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

#Область ОтображениеПериода

&НаКлиенте
Процедура ПериодНачисленияСтрокойНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.РасчетныйПериод = КонецКвартала(РезультатВыбора.КонецПериода);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ОбновитьОписаниУдержанийВыплат(ЭтотОбъект);
	
	УстановитьСостояниеДокумента();
	УстановитьТипУчредителя();
	УправлениеФормой();
	ПериодНачисленияСтрокой = ПредставлениеПериода(НачалоГода(Объект.РасчетныйПериод),
								КонецКвартала(Объект.РасчетныйПериод),
								"ФП = Истина");
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНалогНаСервере()
	
	Если Не (ЗначениеЗаполнено(Объект.Учредитель)
		И ЗначениеЗаполнено(Объект.СуммаДохода)) Тогда
		Объект.СуммаНалога = 0;
		Возврат;
	КонецЕсли;
	
	СуммыНалога = Документы.НачислениеДивидендов.РассчитатьНалог(
		Объект.Учредитель,
		Объект.ТипУчредителя,
		Объект.СуммаДохода,
		Объект.ПланируемаяДатаВыплаты,
		Объект.Организация,
		Объект.Ссылка);
	
	ЗаполнитьЗначенияСвойств(Объект, СуммыНалога);
	
	ОбновитьОписаниУдержанийВыплат(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьПланируемуюДатуВыплаты(ЭтотОбъект);
	ПланируемаяДатаВыплатыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УчредительПриИзмененииНаСервере()
	
	ОбновитьНалог();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипУчредителя()
	
	МассивПараметрыВыбора = Новый Массив;
	Если Объект.ТипУчредителя = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		Элементы.Учредитель.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ЮридическоеФизическоеЛицо", 
			Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
		МассивПараметрыВыбора.Добавить(НовыйПараметр);
		
		Элементы.СуммаНалога.Заголовок = НСтр("ru = 'Налог на прибыль'");
	Иначе
		Элементы.Учредитель.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		Элементы.СуммаНалога.Заголовок = НСтр("ru = 'НДФЛ'");
	КонецЕсли;
	
	Объект.Учредитель = Элементы.Учредитель.ОграничениеТипа.ПривестиЗначение(Объект.Учредитель);
	Элементы.Учредитель.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметрыВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ТипУчредителяПриИзмененииНаСервере()
	
	УстановитьТипУчредителя();
	УчредительПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СуммаДоходаПриИзмененииНаСервере()
	
	ОбновитьНалог();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ПланируемаяДатаВыплатыПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	ОбновитьНалог();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Функция АдресПараметровВХранилище()
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("Объект",                                 РеквизитФормыВЗначение("Объект"));
	ПараметрыРасчета.Вставить("Ссылка",                                 Объект.Ссылка);
	ПараметрыРасчета.Вставить("Организация",                            Объект.Организация);
	ПараметрыРасчета.Вставить("Учредитель",                             Объект.Учредитель);
	ПараметрыРасчета.Вставить("МесяцНачисления",                        НачалоМесяца(Объект.Дата));
	ПараметрыРасчета.Вставить("СуммаНалога",                            Объект.СуммаНалога);
	ПараметрыРасчета.Вставить("СуммаНалогаСПревышения",                 Объект.СуммаНалогаСПревышения);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыРасчета, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура РедактированиеНалогаЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования)
		И ТипЗнч(РезультатРедактирования) = Тип("Структура") Тогда
		
		Если РезультатРедактирования.Свойство("Учредитель")
			И РезультатРедактирования.Учредитель = Объект.Учредитель Тогда
			
			ЗаполнитьЗначенияСвойств(Объект, РезультатРедактирования, "СуммаНалога, СуммаНалогаСПревышения");
			ОбновитьОписаниУдержанийВыплат(ЭтотОбъект);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНалог()
	
	РассчитатьНалогНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОписаниУдержанийВыплат(Форма)
	
	Форма.СуммаНалогаИтог = Форма.Объект.СуммаНалога + Форма.Объект.СуммаНалогаСПревышения;
	Форма.КВыплате        = Форма.Объект.СуммаДохода - Форма.СуммаНалогаИтог;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если Объект.ТипУчредителя = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		
		Элементы.СуммаНалога.Видимость = Истина;
		
		Элементы.СуммаНалога.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.СуммаНалога.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элементы.СуммаНалога.КнопкаВыбора = Истина;
		
		Элементы.ПланируемаяДатаВыплаты.Видимость = Ложь;
		Элементы.ГруппаНалог.Видимость = Ложь;
		
	Иначе
		Если ВыполнятьРасчетНДФЛПоПрогрессивнойШкале Тогда
			Элементы.ГруппаНалог.Видимость = Истина;
			Элементы.СуммаНалога.Видимость = Ложь;
		Иначе
			Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
				Элементы.СуммаНалога.Вид = ВидПоляФормы.ПолеНадписи;
				Элементы.СуммаНалога.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
				Элементы.ГруппаНалог.Видимость = Ложь;
				Элементы.СуммаНалога.Видимость = Истина;
			Иначе
				Элементы.СуммаНалога.Видимость = Истина;
				Элементы.СуммаНалога.Вид = ВидПоляФормы.ПолеВвода;
				Элементы.СуммаНалога.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
				Элементы.СуммаНалога.КнопкаВыбора = Истина;
				Элементы.ГруппаНалог.Видимость    = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ПланируемаяДатаВыплаты.Видимость = УчетЗарплатыИКадровСредствамиБухгалтерии;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	УчетЗарплатыИКадровСредствамиБухгалтерии = ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровСредствамиБухгалтерии");
	Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		
		ВыполнятьРасчетНДФЛПоПрогрессивнойШкале =
			Объект.ПланируемаяДатаВыплаты >= УчетЗарплаты.ДатаНачалаУчетаПрогрессивногоНДФЛ();
		
	Иначе
		
		ВыполнятьРасчетНДФЛПоПрогрессивнойШкале =
			Объект.Дата >= УчетЗарплаты.ДатаНачалаУчетаПрогрессивногоНДФЛ();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередВыплатойСледуетПровестиЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДокументПроведен = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	Если ДокументПроведен Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ВыполненаЗаписьДокумента", Новый Структура("ДокументСсылка", Объект.Ссылка));
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось провести документ'"));
		Возврат;
	КонецЕсли;
	
	СформироватьДокументыВыплаты();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноСоздатьВыплатыПоРасчетномуДокументу(РасчетныйДокумент)
	
	МожноСоздатьВедомости = Истина;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", РасчетныйДокумент);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СписаниеСРасчетногоСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов)
	|	И СписаниеСРасчетногоСчета.Проведен
	|	И (СписаниеСРасчетногоСчета.НачислениеДивидендов = &Ссылка
	|			ИЛИ СписаниеСРасчетногоСчета.ДокументОснование = &Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходныйКассовыйОрдер.Ссылка
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыплатаДивидендов)
	|	И РасходныйКассовыйОрдер.Проведен
	|	И (РасходныйКассовыйОрдер.НачислениеДивидендов = &Ссылка
	|			ИЛИ РасходныйКассовыйОрдер.ДокументОснование = &Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПлатежноеПоручение.Ссылка
	|ИЗ
	|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
	|ГДЕ
	|	ПлатежноеПоручение.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов)
	|	И ПлатежноеПоручение.Проведен
	|	И (ПлатежноеПоручение.НачислениеДивидендов = &Ссылка
	|			ИЛИ ПлатежноеПоручение.ДокументОснование = &Ссылка)";
	
	МожноСоздатьВедомости = Запрос.Выполнить().Пустой();
	
	Возврат МожноСоздатьВедомости;
	
КонецФункции

&НаКлиенте
Функция КлючевыеРеквизитыЗаполнены()
	
	Если Не ЗначениеЗаполнено(Объект.Учредитель) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Необходимо заполнить обязательные для заполнения поля'"));
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СформироватьДокументыВыплаты()
	
	Если МожноСоздатьВыплатыПоРасчетномуДокументу(Объект.Ссылка) Тогда
		
		ОткрытьФорму("Документ.НачислениеДивидендов.Форма.ФормаВыплата",
			Новый Структура("Ключ", Объект.Ссылка),
			ЭтотОбъект,
			УникальныйИдентификатор); 
	Иначе
		ТекстСообщения = НСтр("ru = 'Документ уже оплачен ранее'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

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

#КонецОбласти
