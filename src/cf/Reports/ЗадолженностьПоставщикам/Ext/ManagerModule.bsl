﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Задолженность поставщикам" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПоставщиков();

	ПредопределенныеСчетаАвансов = Новый Массив;
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданным);    // 60.02
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданнымВал); // 60.22
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданнымУЕ);  // 60.32
	СчетаАвансов = БухгалтерскийУчет.СформироватьМассивСубсчетов(ПредопределенныеСчетаАвансов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаАвансов", 				СчетаАвансов);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаСДокументомРасчетов", 	СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаБезДокументаРасчетов", 	СчетаУчетаРасчетов.СчетаБезДокументаРасчетов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыДоговоров", БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков());
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", Новый Граница(НачалоДня(ПараметрыОтчета.НачалоПериода), ВидГраницы.Исключая));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", Дата(1, 1, 1) + 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", Новый Граница (КонецДня(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", Дата(3999, 1, 1) + 1);
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	ОбластьЯчеек = Результат.НайтиТекст("<ДолгНаНачало>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Расчеты на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yy; ДП=..."));
		
		ОбластьЯчеек = Результат.Область(ОбластьЯчеек.Верх, ОбластьЯчеек.Лево, ОбластьЯчеек.Верх + 1, ОбластьЯчеек.Лево + 7);
		ОбластьЯчеек.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	КонецЕсли;
	
	ОбластьЯчеек = Результат.НайтиТекст("<ДолгНаКонец>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Расчеты на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yy; ДП=..."));
		
	КонецЕсли;
	
	БыстрыеНастройкиОтчетовСервер.ВывестиПримечанияОкругления(ПараметрыОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ЗадолженностьПоставщикамПоДоговорам = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамПоДоговорам");
	ЗадолженностьПоставщикамПоДоговорам.ФункциональныеОпции.Добавить("ВестиУчетПоДоговорам");
	ЗадолженностьПоставщикамПоДоговорам.Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПоставщиками, "");
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикам").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПоставщиками, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполниим соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки ИЗ ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		СоответствиеПолей.Вставить(Группировка.Поле);
	КонецЦикла;
	
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 					Истина);
	ДополнительныеСвойства.Вставить("Организация", 							ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода", 						ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода", 						ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",					ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",						ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",						ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения",	ДанныеОтчета.Объект.ВключатьОбособленныеПодразделения);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	Договор = Данные_Расшифровки.Получить("Договор");
	
	Если ЗначениеЗаполнено(Договор) Тогда
		
		ДополнительныеСвойства.Вставить("Организация", Договор.Организация);
		
	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		
	КонецЦикла;
	
	Группировка = Новый Массив();
	ЕстьГруппировкаПоДокументу = Ложь;
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
			
			Если СтрокаГруппировки.Поле = "Документ" Тогда
				
				ЕстьГруппировкаПоДокументу = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьГруппировкаПоДокументу Тогда
		
		СтрокаДляРасшифровки = Новый Структура();
		СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
		СтрокаДляРасшифровки.Вставить("Поле", 			"Документ");
		СтрокаДляРасшифровки.Вставить("Представление", 	"Документ");
		СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
		
		Группировка.Добавить(СтрокаДляРасшифровки);
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	ДополнительныеСвойства.Вставить("ОчищатьТаблицуГруппировок", Истина);
	
	СписокПунктовМеню.Добавить("ЗадолженностьПоставщикам", "Задолженность поставщикам");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("ЗадолженностьПоставщикам", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","ЗадолженностьПоставщикам", "Задолженность поставщикам"));
	Массив.Добавить(Новый Структура("Имя, Представление","ЗадолженностьПоставщикамПоДоговорам", "Задолженность поставщикам по договорам"));
	
	Возврат Массив;
	
КонецФункции

// Формирует таблицу данных для монитора руководителя по организации на дату
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаЗадолженности - Дата - дата на которую нужны остатки
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьЗадолженностьПоставщикамДляМонитораРуководителя(Организация, ДатаЗадолженности) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Если КонецДня(ТекущаяДатаСеанса()) = КонецДня(ДатаЗадолженности) Тогда
		// Если остатки получаются "на сегодня", то обращаемся к текущим итогам регистра.
		Запрос.УстановитьПараметр("Период", Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Период", Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	КонецЕсли;
	
	СубконтоКонтрагентДоговорДокумент = Новый СписокЗначений;
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговорДокумент", СубконтоКонтрагентДоговорДокумент);
	
	СубконтоКонтрагентДоговор = Новый СписокЗначений;
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговор", СубконтоКонтрагентДоговор);
	
	Запрос.УстановитьПараметр("ВидыДоговоров", БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков());
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПоставщиков();
	Запрос.УстановитьПараметр("СчетаСДокументомРасчетов", 	СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	Запрос.УстановитьПараметр("СчетаБезДокументаРасчетов", 	СчетаУчетаРасчетов.СчетаБезДокументаРасчетов);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт КАК Сумма,
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто2 КАК Договор,
	               |	ХозрасчетныйОстатки.Субконто3 КАК Документ
	               |ПОМЕСТИТЬ Остатки
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Период,
	               |			Счет В (&СчетаСДокументомРасчетов),
	               |			&СубконтоКонтрагентДоговорДокумент,
	               |			Организация = &Организация
	               |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт > 0
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Субконто1,
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт,
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто2,
	               |	NULL
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Период,
	               |			Счет В (&СчетаБезДокументаРасчетов),
	               |			&СубконтоКонтрагентДоговор,
	               |			Организация = &Организация
	               |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Остатки.Контрагент,
	               |	СУММА(Остатки.Сумма) КАК Сумма
	               |ИЗ
	               |	Остатки КАК Остатки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Остатки.Контрагент
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Сумма УБЫВ";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	Для ИндексСтроки = 0 По Мин(2, Результат.Количество() - 1) Цикл
		
		СтрокаРезультата = Результат[ИндексСтроки];
		Контрагент = СтрокаРезультата.Контрагент;
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.Представление 		= Контрагент;
		СтрокаДанных.Данныерасшифровки 	= Контрагент;
		СтрокаДанных.Порядок 			= ПорядокЗадолженностейВМониторе();
		СтрокаДанных.Сумма 				= СтрокаРезультата.Сумма;
		
	КонецЦикла;
	
	// Добавляем итог по разделу
	СтрокаДанных = ТаблицаДанных.Добавить();
	СтрокаДанных.Представление 	= НСтр("ru = 'Итого'");
	СтрокаДанных.Порядок        = ПорядокИтоговВМониторе();
	СтрокаДанных.Сумма 			= Результат.Итог("Сумма");
	
	Возврат ТаблицаДанных;
	
КонецФункции 

// Формирует таблицу данных для монитора руководителя по организации на дату
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаЗадолженности - Дата - дата на которую нужны остатки
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьЗадолженностьПоставщикамДляМонитораРуководителяСводно(Организация, ДатаЗадолженности) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Если КонецДня(ТекущаяДатаСеанса()) = КонецДня(ДатаЗадолженности) Тогда
		// Если остатки получаются "на сегодня", то обращаемся к текущим итогам регистра.
		Запрос.УстановитьПараметр("Период", Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Период", Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	КонецЕсли;
	
	СубконтоКонтрагентДоговорДокумент = Новый СписокЗначений;
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	СубконтоКонтрагентДоговорДокумент.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговорДокумент", СубконтоКонтрагентДоговорДокумент);
	
	СубконтоКонтрагентДоговор = Новый СписокЗначений;
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	СубконтоКонтрагентДоговор.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос.УстановитьПараметр("СубконтоКонтрагентДоговор", СубконтоКонтрагентДоговор);
	
	Запрос.УстановитьПараметр("ВидыДоговоров", БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков());
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПоставщиков();
	Запрос.УстановитьПараметр("СчетаСДокументомРасчетов", 	СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	Запрос.УстановитьПараметр("СчетаБезДокументаРасчетов", 	СчетаУчетаРасчетов.СчетаБезДокументаРасчетов);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт КАК Сумма,
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто2 КАК Договор,
	               |	ХозрасчетныйОстатки.Субконто3 КАК Документ
	               |ПОМЕСТИТЬ Остатки
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Период,
	               |			Счет В (&СчетаСДокументомРасчетов),
	               |			&СубконтоКонтрагентДоговорДокумент,
	               |			Организация = &Организация
	               |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт > 0
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Субконто1,
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт,
	               |	ХозрасчетныйОстатки.Счет,
	               |	ХозрасчетныйОстатки.Субконто2,
	               |	NULL
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
	               |			&Период,
	               |			Счет В (&СчетаБезДокументаРасчетов),
	               |			&СубконтоКонтрагентДоговор,
	               |			Организация = &Организация
	               |				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.СуммаРазвернутыйОстатокКт > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(Остатки.Сумма) КАК Сумма
	               |ИЗ
	               |	Остатки КАК Остатки";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	// Добавляем итог по разделу
	СтрокаДанных = ТаблицаДанных.Добавить();
	СтрокаДанных.Представление 	= НСтр("ru = 'Итого'");
	СтрокаДанных.Порядок        = ПорядокИтоговВМониторе();
	СтрокаДанных.Сумма 			= Выборка.Сумма;
	
	Возврат ТаблицаДанных;
	
КонецФункции 

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьПримечанияОкругления"     , Ложь);

	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
Функция ПорядокИтоговВМониторе() Экспорт
	
	Возврат 0;
	
КонецФункции

Функция ПорядокЗадолженностейВМониторе() Экспорт
	
	Возврат 1;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли