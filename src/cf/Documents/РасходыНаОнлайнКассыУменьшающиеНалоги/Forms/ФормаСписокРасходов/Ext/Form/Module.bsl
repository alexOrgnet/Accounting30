﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"УменьшаемыйНалог, Организация, НалоговыйПериод, РегистрацияВНалоговомОргане");
	
	УстановитьОтборыДинамическогоСписка();
	
	ОбновитьИтоги();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.РасходыНаОнлайнКассыУменьшающиеНалоги);
	
	Элементы.ФормаСоздать.Видимость                   = МожноРедактировать;
	Элементы.ФормаУстановитьПометкуУдаления.Видимость = МожноРедактировать;
	
	Элементы.СписокКонтекстноеМенюСоздатьДокумент.Видимость    = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюУдалитьДокумент.Видимость    = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ОбновитьИтоги();
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьДокумент(ДанныеСтроки.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ДобавитьДокумент();
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	ДобавитьДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДокумент(Команда)
	
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьДокумент(ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокумент(Команда)
	
	ДанныеСтроки = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Удалить %1 ""%2"" №%3?'"),
			НСтр("ru = 'Расходы на покупку онлайн-кассы'"),
			ДанныеСтроки.Модель,
			ДанныеСтроки.РегистрационныйНомер);
		
		ДополнительныеПараметры = Новый Структура("Ссылка", ДанныеСтроки.Ссылка);
		Оповещение = Новый ОписаниеОповещения("УдалитьДокументЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьДокумент()
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата", КонецНалоговогоПериода(НалоговыйПериод, УменьшаемыйНалог));
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("УменьшаемыйНалог", УменьшаемыйНалог);
	ЗначенияЗаполнения.Вставить("РегистрацияВНалоговомОргане", РегистрацияВНалоговомОргане);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ВызовИзПомощника",   Истина);
	
	ОткрытьФорму("Документ.РасходыНаОнлайнКассыУменьшающиеНалоги.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Ссылка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Ссылка);
	ПараметрыФормы.Вставить("ВызовИзПомощника", Истина);
	
	ОткрытьФорму("Документ.РасходыНаОнлайнКассыУменьшающиеНалоги.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		УдалитьДокументНаСервере(ДополнительныеПараметры.Ссылка);
		
		ОповеститьОбИзменении(ДополнительныеПараметры.Ссылка);
		Оповестить("Запись_РасходыНаКассовуюТехнику");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументНаСервере(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.УстановитьПометкуУдаления(Истина);
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	Если УменьшаемыйНалог = Перечисления.ВидыНалоговУменьшаемыхНаРасходыККТ.ЕНВД Тогда
		
		ИтогВсегоРасходов = РегистрыНакопления.РасходыНаОнлайнКассыУменьшающиеЕНВД.ЗарегистрированоВсего(
			Организация,
			КонецНалоговогоПериода(НалоговыйПериод, УменьшаемыйНалог),
			РегистрацияВНалоговомОргане);
			
	ИначеЕсли УменьшаемыйНалог = Перечисления.ВидыНалоговУменьшаемыхНаРасходыККТ.Патент Тогда
		
		РасходыВсего = РегистрыСведений.РасходыНаОнлайнКассыУменьшающиеНалогПСН.ЗарегистрированныеРасходы(
			Организация,
			РегистрацияВНалоговомОргане);
		
		ИтогВсегоРасходов = РасходыВсего.Сумма;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	Если УменьшаемыйНалог <> Перечисления.ВидыНалоговУменьшаемыхНаРасходыККТ.ЕНВД Тогда
		// Отбор по периоду устанавливаем только для расходов, уменьшающих ЕНВД.
		Возврат;
	КонецЕсли;
	
	ОтборКомпоновкиДанных = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборКомпоновкиДанных,
		"Дата",
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		КонецНалоговогоПериода(НалоговыйПериод, УменьшаемыйНалог),
		,
		Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КонецНалоговогоПериода(НалоговыйПериод, УменьшаемыйНалог)
	
	Если УменьшаемыйНалог = ПредопределенноеЗначение("Перечисление.ВидыНалоговУменьшаемыхНаРасходыККТ.ЕНВД") Тогда
		Возврат КонецКвартала(НалоговыйПериод);
	Иначе
		Возврат КонецДня(НалоговыйПериод);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
