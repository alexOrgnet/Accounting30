﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Объект") Тогда
		КопироватьДанныеФормы(Параметры.Объект, Объект);
	КонецЕсли;
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьНаВыплатуЗарплатыФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНачисленияПоДоговорам") Тогда
		ВидВыплатыДоговорПодряда = Элементы.СпособВыплатыЧислом.СписокВыбора.НайтиПоЗначению(2);
		Если ВидВыплатыДоговорПодряда <> Неопределено Тогда
			Элементы.СпособВыплатыЧислом.СписокВыбора.Удалить(ВидВыплатыДоговорПодряда);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьСтатьюРасходов();
	
	ПредупреждениеВыдачаЗПНаличнымиАУСН =
		УправлениеПредупреждениямиАУСНВызовСервера.ТекстПредупрежденияВыплатаЗПНаличными();
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	
	УправлениеФормой();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ВедомостьНаВыплатуЗарплатыФормы.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВедомостьНаВыплатуЗарплатыКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ЗаполнитьДанныеОВыплатеЗначениямиПоУмолчанию();
	
	ВедомостьНаВыплатуЗарплатыФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьНаВыплатуЗарплатыФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи); 
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ВедомостьНаВыплатуЗарплатыВКассу", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере() Экспорт
	
	ИспользоватьРасчетПервойПоловиныМесяца =
		УчетЗарплаты.ИспользоватьРасчетПервойПоловиныМесяца(Объект.Организация, Объект.ПериодРегистрации);
	
	УправлениеФормой();
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СпособВыплатыПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СпособВыплатыПриИзмененииНаСервере(ЭтотОбъект);
	Если Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.Аванс()
		И Не ИспользоватьРасчетПервойПоловиныМесяца Тогда
		Для Каждого СтрокаТаблицы ИЗ Объект.Зарплата Цикл
			СтрокаТаблицы.ДокументОснование = "";
			СтрокаТаблицы.ПериодВзаиморасчетов = Объект.ПериодРегистрации;
		КонецЦикла;
		Если Объект.НДФЛ.Количество() <> 0 Тогда
			Объект.НДФЛ.Очистить();
			Для Каждого СтрокаСостава ИЗ Объект.Состав Цикл
				ПриПолученииДанныхСтрокиСостава(СтрокаСостава);
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ДоговорПодряда() Тогда
		Объект.Подразделение = "";
	КонецЕсли;
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КомментарийНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура СпособВыплатыЧисломПриИзменении(Элемент)
	
	ИзменитьСпособВыплатыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Оплатить(Команда)
	
	Если Объект.ПометкаУдаления Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Нельзя оформить выплату на основании документа, помеченного на удаление.'"));
		Возврат;
	Иначе
		Если НЕ Объект.Проведен ИЛИ Модифицированность Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Вставить(0, КодВозвратаДиалога.Да,     "Провести");
			Кнопки.Вставить(1, КодВозвратаДиалога.Отмена, "Отмена");
			
			Оповещение = Новый ОписаниеОповещения("ВопросПередВыплатойСледуетПровестиЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед выплатой документ следует провести'"), Кнопки,, КодВозвратаДиалога.Да);
		Иначе
			ОплатитьВедомость();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "СоставКВыплатеРасшифровка" Тогда
		ВедомостьНаВыплатуЗарплатыКлиент.СоставВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
	ИначеЕсли Поле.Имя = "ФизическоеЛицо" Тогда
		ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(,ТекущиеДанные.ФизическоеЛицо);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "СоставНДФЛСумма"
		ИЛИ Поле.Имя = "СоставНДФЛРасшифровка" Тогда
		РедактироватьНДФЛСтроки(Элементы.Состав.ТекущиеДанные);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыФормы.СоставОбработкаВыбораНаСервере(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ВедомостьНаВыплатуЗарплатыКлиент.Подобрать(ЭтотОбъект);
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставПередУдалением(ЭтотОбъект, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СоставПослеУдаленияНаСервере(ЭтотОбъект)
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеПриИзменении(Элемент)
	СоставКВыплатеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоставКВыплатеПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СоставКВыплатеПриИзмененииНаСервере(ЭтотОбъект);
	ОбновитьНДФЛНаСервере(Новый ФиксированныйМассив(ЭтотОбъект.Элементы.Состав.ВыделенныеСтроки));
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеОткрытие(Элемент, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставКВыплатеОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Заполнить(Команда)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЗаполнениеДокументаВедомостьНаВыплатуЗарплатыВКассу");
	ВедомостьНаВыплатуЗарплатыКлиент.Заполнить(ЭтотОбъект)
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ВедомостьНаВыплатуЗарплатыКлиент.Подобрать(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗарплату(Команда)
	РедактироватьЗарплатуСтроки(Элементы.Состав.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНДФЛ(Команда)
	ВедомостьНаВыплатуЗарплатыКлиент.ОбновитьНДФЛ(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.ОплатаПоказать(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении()
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов()
КонецФункции

#КонецОбласти

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбратныеВызовы

// АПК:78-выкл Для функций, вызываемых из общей функциональности ведомостей, экспорт необходим

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьНаВыплатуЗарплатыФормы.ЗаполнитьПервоначальныеЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект) Экспорт

	ИспользоватьРасчетПервойПоловиныМесяца =
		УчетЗарплаты.ИспользоватьРасчетПервойПоловиныМесяца(ТекущийОбъект.Организация, ТекущийОбъект.ПериодРегистрации);
		
	ВедомостьНаВыплатуЗарплатыФормы.ПриПолученииДанныхНаСервере(ЭтотОбъект, ТекущийОбъект);

	Если Параметры.Ключ.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.СпособВыплаты) Тогда
			Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.Аванс() Тогда
		СпособВыплатыЧислом = 1;
	ИначеЕсли Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ДоговорПодряда() Тогда
		СпособВыплатыЧислом = 2;
	Иначе
		СпособВыплатыЧислом = 0;
	КонецЕсли;
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ПриПолученииДанныхСтрокиСостава(ЭтотОбъект, СтрокаСостава)
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ОбработатьСообщенияПользователю(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьДоступностьЭлементов(ЭтотОбъект);
	
	ЕстьОплатаПоВедомости = ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Объект.Ссылка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаОплатыКнопка",
		"Видимость",
		НЕ ЕстьОплатаПоВедомости);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаОплатыСсылка",
		"Видимость",
		ЕстьОплатаПоВедомости);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"Оплатить",
		"Доступность",
		НЕ ТолькоПросмотр);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьПредставлениеОплаты(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт

	Если НЕ ЗначениеЗаполнено(Объект.Округление) Тогда
		Объект.Округление = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплатыФормы.ЗаполнитьНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНДФЛНаСервере(ИдентификаторыСтрок) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ОбновитьНДФЛНаСервере(ЭтотОбъект, ИдентификаторыСтрок)
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников() Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресСпискаПодобранныхСотрудников(ЭтотОбъект)
КонецФункции

&НаКлиенте
Процедура РедактироватьЗарплатуСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьЗарплатуСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьЗарплатуСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьНДФЛСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеЗарплатыПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеНДФЛПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции	

// АПК:78-вкл

#КонецОбласти

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.СоставНДФЛГруппа.Видимость = СпособВыплатыЧислом <> 1
		Или ИспользоватьРасчетПервойПоловиныМесяца;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодразделениеОрганизации",
		"Видимость",
		СпособВыплатыЧислом <> 2);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СоставОбновитьНДФЛ",
		"Видимость",
		СпособВыплатыЧислом <> 1
		Или ИспользоватьРасчетПервойПоловиныМесяца);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Организация",
		"Доступность",
		Не Параметры.КонтекстныйВызов);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПериодРегистрации",
		"Доступность",
		Не Параметры.КонтекстныйВызов);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СпособВыплаты",
		"Доступность",
		Не Параметры.КонтекстныйВызов
		Или (ПолучитьФункциональнуюОпцию("ИспользоватьНачисленияПоДоговорам")
			И СпособВыплатыЧислом <> 1));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СпособВыплатыЧислом1",
		"Доступность",
		Не Параметры.КонтекстныйВызов);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СпособВыплатыЧислом2",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНачисленияПоДоговорам"));
		
	КонецПроцедуры

&НаСервере
Процедура ИзменитьСпособВыплатыНаСервере()
	
	Если СпособВыплатыЧислом = 1 Тогда
		Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.Аванс();
	ИначеЕсли СпособВыплатыЧислом = 2 Тогда
		Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ДоговорПодряда();
	Иначе
		Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ПоУмолчанию();
	КонецЕсли;
	Объект.Округление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СпособВыплаты, "Округление");
	СпособВыплатыПриИзмененииНаСервере();
	УстановитьСтатьюРасходов();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = 0;
	ЗарплатаКадрыПереопределяемый.СостояниеДокумента(Объект, СостояниеДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередВыплатойСледуетПровестиЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДокументПроведен = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	Если НЕ ДокументПроведен Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось провести документ'"));
		Возврат;
	КонецЕсли;
	
	ОплатитьВедомость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВедомость()
	
	Если СпособВыплатыЧислом = 2 Тогда
		ОткрытьФорму("Обработка.ВыплатаЗарплатыРасходнымиОрдерами.Форма", Новый Структура("ПлатежнаяВедомость", Объект.Ссылка));
	Иначе
		ОплатитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОплатитьНаСервере()
	
	ВедомостьНаВыплатуЗарплатыФормыПереопределяемый.СформироватьДокументыОплаты(ЭтотОбъект);
	УстановитьПредставлениеОплаты();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#Область ВызовыСервера

&НаСервере
Процедура ЗаполнитьДанныеОВыплатеЗначениямиПоУмолчанию()
	
	Если НЕ ЗначениеЗаполнено(Объект.СпособВыплаты) Тогда
		Объект.СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.ПоУмолчанию();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Округление) Тогда
		Объект.Округление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СпособВыплаты, "Округление");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьСтатьюРасходов()
	
	СтатьяРасходов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СпособВыплаты, "СтатьяРасходов");
	
КонецПроцедуры

#КонецОбласти

