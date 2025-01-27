﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	ПрочитатьОтветственноеЛицо();
	
	НеавтоматизированнаяТорговаяТочка = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьНоменклатурнуюГруппуНТТ(ЭтотОбъект);
		ПрочитатьТорговыеТочкиСклада();
		УстановитьВидимостьТорговыхТочек();
	КонецЕсли;

	Элементы.ОтветственноеЛицо.ТолькоПросмотр = НЕ ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ОтветственныеЛица);
	
	Элементы.ОсобыйПорядокНалогообложенияРедактирование.Видимость      = 
		ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПорядокНалогообложенияТорговыхТочек);
	Элементы.ОсобыйПорядокНалогообложенияРедактирование.ТолькоПросмотр = 
		Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ПорядокНалогообложенияТорговыхТочек);
	
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.Справочник.Склады",
		"ФормаЭлемента",
		НСтр("ru='Новости: Склад'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.СоответствиеСкладовТорговымТочкам.Форма.ВыборЗначенийИзСписка" Тогда
		ТорговыеТочкиСклада.ЗагрузитьЗначения(ВыбранноеЗначение);
		ТорговыеТочкиПредставление = ПредставлениеТорговыхТочек(ТорговыеТочкиСклада);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьФорму"
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("ИмяЭлемента")
		И Параметр.ИмяЭлемента = "ОтветственноеЛицо" Тогда
		
		ПрочитатьОтветственноеЛицо();
		
	ИначеЕсли ИмяСобытия = "Запись_ТорговыеТочки"
		И Не Объект.Ссылка.Пустая() Тогда
		
		ОбновитьСписокТорговыхТочекСклада(Источник, Параметр);
		
	КонецЕсли;
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ПрочитатьПорядокНалогообложения();
	
	ПрочитатьТорговыеТочкиСклада();
	УстановитьВидимостьТорговыхТочек();
	
	УправлениеФормой(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ЗаписатьОтветственноеЛицо(ТекущийОбъект.Ссылка, Отказ);
	ЗаписатьПорядокНалогообложенияТорговыхТочек(ТекущийОбъект.Ссылка, Отказ);
	ЗаписатьТорговыеТочкиСклада(ТекущийОбъект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьТорговыеТочкиСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыЗаписи.Вставить("ТорговыеТочки", ТорговыеТочкиСклада.ВыгрузитьЗначения());
	Оповестить("Запись_Склада", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТипСкладаПриИзменении(Элемент)

	ТипСкладаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыеТочкиПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВыбратьИзСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуВыбораСкладовТорговойТочки();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИсторияОтветственныхЛиц(Команда)

	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("СтруктурнаяЕдиница", Объект.Ссылка));
	ОткрытьФорму("РегистрСведений.ОтветственныеЛица.ФормаСписка", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(
		ЭтотОбъект,
		ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();


	// ТипЦенРозничнойТорговли

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТипЦенРозничнойТорговли");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ТипСклада", ВидСравненияКомпоновкиДанных.Равно, Перечисления.ТипыСкладов.ОптовыйСклад);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаУчетВПродажныхЦенах.Видимость          = Объект.ТипСклада = Форма.НеавтоматизированнаяТорговаяТочка;
	Элементы.ГруппаОсобыйПорядокНалогообложения.Видимость = Объект.ТипСклада = Форма.НеавтоматизированнаяТорговаяТочка;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОтветственноеЛицо()

	ОтветственноеЛицо = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(Объект.Ссылка, ТекущаяДатаСеанса());

КонецПроцедуры

&НаСервере
Процедура ЗаписатьОтветственноеЛицо(СсылкаНаОбъект, Отказ)

	Отбор = Новый Структура("СтруктурнаяЕдиница");
	Отбор.СтруктурнаяЕдиница = СсылкаНаОбъект;
	СрезПоследних = РегистрыСведений.ОтветственныеЛица.СрезПоследних(ТекущаяДатаСеанса(), Отбор);
	
	НаборЗаписей = РегистрыСведений.ОтветственныеЛица.СоздатьНаборЗаписей();

	Если СрезПоследних.Количество() < 1 Тогда
		Если НЕ ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
			Возврат;
		Иначе
			ПериодЗаписи = '19800101';
			
			// Начальное значение записываем на условную "нулевую" дату лежащую в далеком прошлом, поэтому проверка запрета изменений должна быть отключена.
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
		КонецЕсли;
	Иначе
		Если ОтветственноеЛицо = СрезПоследних[0].ФизическоеЛицо Тогда
			Возврат;
		Иначе
			ПериодЗаписи = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
	НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(СсылкаНаОбъект);
	
	ЗаписьРегистра = НаборЗаписей.Добавить();

	ЗаписьРегистра.Период             = ПериодЗаписи;
	ЗаписьРегистра.СтруктурнаяЕдиница = СсылкаНаОбъект;
	ЗаписьРегистра.ФизическоеЛицо     = ОтветственноеЛицо;

	Попытка
		НаборЗаписей.Записать();
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось записать данные об ответственном лице 
                                |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, КраткоеПредставлениеОшибки(ОписаниеОшибки()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ);
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ОписаниеОшибки()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Установка ответственного лица'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.Склады,
			СсылкаНаОбъект, 
			ТекстСообщения);
	КонецПопытки;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНоменклатурнуюГруппуНТТ(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.ТипСклада = Форма.НеавтоматизированнаяТорговаяТочка И НЕ ЗначениеЗаполнено(Объект.НоменклатурнаяГруппа) Тогда
		Объект.НоменклатурнаяГруппа = БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа();
	ИначеЕсли НЕ Объект.ТипСклада = Форма.НеавтоматизированнаяТорговаяТочка Тогда
		Объект.НоменклатурнаяГруппа =Неопределено;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

&НаКлиенте
Процедура ОтветственноеЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение <> ОтветственноеЛицо Тогда
		Модифицированность = Истина;
	КонецЕсли; 
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ИсторияИзмененийНТТ(Команда)
	
	ПараметрыОтбора = Новый Структура("Склад", Объект.Ссылка);
	ОткрытьФорму("РегистрСведений.ПорядокНалогообложенияТорговыхТочек.Форма.ФормаСписка", Новый Структура("Отбор", ПараметрыОтбора));
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПорядокНалогообложения()
	
	Если Не ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПорядокНалогообложенияТорговыхТочек) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		ОсобыйПорядокНалогообложения = РегистрыСведений.ПорядокНалогообложенияТорговыхТочек.ОсобыйПорядокНалогообложенияНаСкладе(Объект.Ссылка, ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПорядокНалогообложенияТорговыхТочек(СсылкаНаОбъект, Отказ)
	
	Если Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ПорядокНалогообложенияТорговыхТочек) Тогда
		Возврат;
	КонецЕсли;
	
	Если СсылкаНаОбъект.ТипСклада <> Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Склад");
	Отбор.Склад = СсылкаНаОбъект;
	СрезПоследних = РегистрыСведений.ПорядокНалогообложенияТорговыхТочек.СрезПоследних(ТекущаяДатаСеанса(), Отбор);
	
	Если СрезПоследних.Количество() < 1 Тогда
		ПериодЗаписи = '19800101';
	Иначе
		Если ОсобыйПорядокНалогообложения = СрезПоследних[0].ОсобыйПорядокНалогообложения Тогда
			Возврат;
		Иначе
			ПериодЗаписи = НачалоМесяца(ТекущаяДатаСеанса());
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПорядокНалогообложенияТорговыхТочек.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	
	НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
	НаборЗаписей.Отбор.Склад.Установить(СсылкаНаОбъект);
	
	ЗаписьРегистра = НаборЗаписей.Добавить();
	
	ЗаписьРегистра.Период                       = ПериодЗаписи;
	ЗаписьРегистра.Склад                        = СсылкаНаОбъект;
	ЗаписьРегистра.ОсобыйПорядокНалогообложения = ОсобыйПорядокНалогообложения;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось записать данные о порядке налогообложения торговой точки
	                                  |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, КраткоеПредставлениеОшибки(ОписаниеОшибки()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ);
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ОписаниеОшибки()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Установка порядка налогообложения для склада'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.Склады,
			СсылкаНаОбъект,
			ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ТипСкладаПриИзмененииНаСервере()
	
	ПрочитатьПорядокНалогообложения();
	
	УправлениеФормой(ЭтотОбъект);
	
	ЗаполнитьНоменклатурнуюГруппуНТТ(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТорговыеТочкиСклада()
	
	Если НЕ ПолучитьФункциональнуюОпцию("УплачиваетсяТорговыйСбор") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		МассивТорговыхТочек = РегистрыСведений.СоответствиеСкладовТорговымТочкам.ТорговыеТочкиСклада(Объект.Ссылка);
		
		ТорговыеТочкиСклада.ЗагрузитьЗначения(МассивТорговыхТочек);
	КонецЕсли;
	
	ТорговыеТочкиПредставление = ПредставлениеТорговыхТочек(ТорговыеТочкиСклада);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТорговыеТочкиСклада(СсылкаНаОбъект)
	
	Если НЕ ПолучитьФункциональнуюОпцию("УплачиваетсяТорговыйСбор") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() И ТорговыеТочкиСклада.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СоответствиеСкладовТорговымТочкам.ЗаписатьИзмененияВСоответствииТорговыхТочекСкладу(
		СсылкаНаОбъект, ТорговыеТочкиСклада.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьТорговыхТочек()
	
	ВидимостьЭлемента = ПолучитьФункциональнуюОпцию("УплачиваетсяТорговыйСбор")
		И ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.СоответствиеСкладовТорговымТочкам);
	
	Элементы.ТорговыеТочкиПредставление.Видимость = ВидимостьЭлемента;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеТорговыхТочек(ТорговыеТочкиСклада)
	
	МассивСтрок = Новый Массив;
	КоличествоТорговыхТочек = ТорговыеТочкиСклада.Количество();
	
	Если КоличествоТорговыхТочек > 0 Тогда
		
		Предмет = Нстр("ru = 'торговая точка,торговых точки,торговых точек,ж,,,,0'");
		ПредставлениеПредмета = ОбщегоНазначенияБПКлиентСервер.ПредставлениеСсылкиПредмета(
			Предмет, Нстр("ru = 'торгов'"), ТорговыеТочкиСклада[0].Значение, КоличествоТорговыхТочек);
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ПредставлениеПредмета, , , , "ВыбратьИзСписка"));
		
	Иначе
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(Нстр("ru = 'Выбрать'"), , , , "ВыбратьИзСписка"));
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораСкладовТорговойТочки()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",    Нстр("ru = 'Торговые точки склада'"));
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",        "Справочник.ТорговыеТочки");
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", ТорговыеТочкиСклада.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("ПоказыватьОрганизации",   Истина);
	ПараметрыФормы.Вставить("ТолькоПросмотр",          ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.СоответствиеСкладовТорговымТочкам.Форма.ВыборЗначенийИзСписка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокТорговыхТочекСклада(ТорговаяТочка, ПараметрыОбновления)
	
	Если НЕ ПараметрыОбновления.Свойство("Склады") Тогда
		Возврат; // Переданы не все необходимые параметры.
	КонецЕсли;
	
	// Получим значение связи торговой точки со складом в текущей форме и в форме, которая разослала оповещение.
	// Изменять связь торговой точки со складом будем только в том случае, если значения отличаются.
	ЗначениеСвязиВТекущейФорме = ТорговыеТочкиСклада.НайтиПоЗначению(ТорговаяТочка) <> Неопределено;
	ЗначениеСвязиВОповещении   = ПараметрыОбновления.Склады.Найти(Объект.Ссылка) <> Неопределено;
	
	Если ЗначениеСвязиВТекущейФорме <> ЗначениеСвязиВОповещении Тогда
		
		// Изменяем значение связи только с переданной торговой точкой,
		// чтобы не затереть изменения в связях с другими торговыми точками, которые мог изменить пользователь.
		Если ЗначениеСвязиВОповещении Тогда
			ТорговыеТочкиСклада.Добавить(ТорговаяТочка);
		Иначе
			ЭлементДляУдаления = ТорговыеТочкиСклада.НайтиПоЗначению(ТорговаяТочка);
			ТорговыеТочкиСклада.Удалить(ЭлементДляУдаления);
		КонецЕсли;
		
	КонецЕсли;
	
	ТорговыеТочкиПредставление = ПредставлениеТорговыхТочек(ТорговыеТочкиСклада);
	
КонецПроцедуры

#КонецОбласти
