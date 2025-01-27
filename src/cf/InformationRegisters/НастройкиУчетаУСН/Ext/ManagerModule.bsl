﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура устанавливает значения регистра по умолчанию
//
// Параметры:
//   Запись           - РегистрСведенийЗапись - запись регистра
//   ДанныеЗаполнения - Структура - где ключ - имя ресурса
//
Процедура УстановкаНастроекПоУмолчанию(Запись, ДанныеЗаполнения) Экспорт
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Период",
		НачалоГода(ТекущаяДатаСеанса()));
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Организация",
		БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));

	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокОтраженияАванса",
		Перечисления.ПорядокОтраженияАвансов.ДоходУСН);
	
	// Определение ставки по умолчанию
	СтавкиПоУмолчанию = УчетУСНКлиентСервер.НалоговыеСтавкиПоУмолчанию();
	СтавкаНалога = СтавкиПоУмолчанию.СтавкаУСНДоходы;
	
	НалоговыеКаникулы = Ложь;
	Если ДанныеЗаполнения.Свойство("НалоговыеКаникулы") Тогда
		НалоговыеКаникулы = ДанныеЗаполнения.НалоговыеКаникулы;
	Иначе
		НалоговыеКаникулы = УчетнаяПолитика.НалоговыеКаникулыУСН(Запись.Организация, Запись.Период);
	КонецЕсли;
	Если НалоговыеКаникулы Тогда
		СтавкаНалога = 0;
	Иначе
		ПрименяетсяУСНДоходыМинусРасходы = Ложь;
		Если ДанныеЗаполнения.Свойство("ПрименяетсяУСНДоходыМинусРасходы") Тогда
			ПрименяетсяУСНДоходыМинусРасходы = ДанныеЗаполнения.ПрименяетсяУСНДоходыМинусРасходы;
		Иначе
			ПрименяетсяУСНДоходыМинусРасходы = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Запись.Организация, Запись.Период);
		КонецЕсли;
		Если ПрименяетсяУСНДоходыМинусРасходы Тогда
			СтавкаНалога = СтавкиПоУмолчанию.СтавкаУСНДоходыМинусРасходы;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"СтавкаНалога",
		СтавкаНалога);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"НалоговыеКаникулы",
		НалоговыеКаникулы);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ОснованиеЛьготнойСтавки",
		"");
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Патент",
		Справочники.Патенты.ПустаяСсылка());
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокПризнанияДопРасходов",
		Перечисления.ПорядокПризнанияДопРасходов.ВключатьВСтоимость);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокПризнанияТаможенныхПлатежей",
		Перечисления.ПорядокПризнанияТаможенныхПлатежей.ВключатьВСтоимость);
		
	// Учет расходов
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокПризнанияМатериальныхРасходов",
		Перечисления.ПорядокПризнанияМатериальныхРасходов.ПоОплатеПоставщику);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокПризнанияРасходовПоТоварам",
		Перечисления.ПорядокПризнанияРасходовПоТоварам.ПоФактуРеализации);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПорядокПризнанияРасходовПоНДС",
		Перечисления.ПорядокПризнанияРасходовПоНДС.ВключатьВСтоимость);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"МетодРаспределенияРасходовПоВидамДеятельности",
		Перечисления.МетодыРаспределенияРасходовУСНПоВидамДеятельности.ЗаКвартал);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"БазаРаспределенияРасходовПоВидамДеятельности",
		Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыПринимаемыеНУ);
	
КонецПроцедуры

// Устанавливает отметку выполнения ввода остатков при смене объекта УСН
//
// Параметры:
//  Организация  - СправочникСсылка.Организация
//  ДатаПерехода - Дата - Период с которого применяется новый объект УСН
//
Процедура УстановитьОтметкуВыполненияВводаОстатковПриСменеОбъектаУСН(Организация, ДатаПерехода) Экспорт
	
	Запись = РегистрыСведений.НастройкиУчетаУСН.СоздатьМенеджерЗаписи();
	Запись.Организация = Организация;
	Запись.Период = ДатаПерехода;
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Запись.НапоминатьОВведенииОстатков = Ложь;
		Запись.Записать();
	КонецЕсли;

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ОбособленныеПодразделения 
	|	ПО ОбособленныеПодразделения.ГоловнаяОрганизация = ЭтотСписок.Организация.ГоловнаяОрганизация
	|;
	|РазрешитьЧтение
	|ГДЕ
	| ЗначениеРазрешено(ОбособленныеПодразделения.Ссылка)
	|
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	| ЗначениеРазрешено(ЭтотСписок.Организация)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПубликацияДанных

// Возвращает идентификатор для вызова через внешний программный интерфейс.
//
// Возвращаемое значение:
//   Строка - идентификатор данных о ставке налога УСН.
//
Функция ПубликуемыйИдентификатор() Экспорт
	
	Возврат "usn_rate";
	
КонецФункции

// Возвращает данные для публикации через внешний программный интерфейс.
// Параметры:
//  Организация - СправочникСсылка.Организация
//
// Возвращаемое значение:
//  Структура:
//   * tariff - Строка
//   * payment - Булево
//   * date - Дата
//
Функция ПубликуемыеДанные(Организация) Экспорт
	
	ПубликуемыеДанные = Новый Структура;

	СведенияОСтавкеУСН = СтавкаУСН(Организация);
	Для Каждого ПравилоПубликации Из ПравилаПубликацииСтавкиУСН() Цикл
		ПубликацияДанных.ОпубликоватьЗначениеПоПравилу(СведенияОСтавкеУСН, ПравилоПубликации, ПубликуемыеДанные);
	КонецЦикла;
	
	Возврат ПубликуемыеДанные;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура Подключаемый_ПередЗаписью(Запись) Экспорт
	
	ПорядокОтраженияАванса = НастройкиУчетаУСНФормыВызовСервера.СписокВыбораОтраженияАвансов(Запись,
		Новый СписокЗначений,
		НастройкиУчетаУСНФормыВызовСервера.СписокПатентов(Запись.Организация, Запись.Период));
	
	Если ТипЗнч(ПорядокОтраженияАванса) = Тип("ПеречислениеСсылка.ПорядокОтраженияАвансов") Тогда
		Запись.ПорядокОтраженияАванса = ПорядокОтраженияАванса;
	КонецЕсли;

КонецПроцедуры

Функция СтавкаУСН(Организация)
	
	СведенияОСтавкеУСН = Новый Структура;
	СведенияОСтавкеУСН.Вставить("Период", '00010101');
	СведенияОСтавкеУСН.Вставить("СтавкаНалога", 6);
	СведенияОСтавкеУСН.Вставить("НомерСтатьи", "");
	СведенияОСтавкеУСН.Вставить("Пункт", "");
	СведенияОСтавкеУСН.Вставить("Подпункт", "");
	СведенияОСтавкеУСН.Вставить("НалоговыеКаникулы", Ложь);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиУчетаУСНСрезПоследних.Период КАК Период,
		|	НастройкиУчетаУСНСрезПоследних.СтавкаНалога КАК СтавкаНалога,
		|	НастройкиУчетаУСНСрезПоследних.ОснованиеЛьготнойСтавки КАК ОснованиеЛьготнойСтавки,
		|	НастройкиУчетаУСНСрезПоследних.НалоговыеКаникулы КАК НалоговыеКаникулы
		|ИЗ
		|	РегистрСведений.НастройкиУчетаУСН.СрезПоследних(&Период, Организация = &Организация) КАК НастройкиУчетаУСНСрезПоследних";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СведенияОСтавкеУСН, Выборка);
		
		ЗаполнитьЗначенияСвойств(СведенияОСтавкеУСН,
			УчетУСНКлиентСервер.НормативныеДанныеОснованияЛьготы(Выборка.ОснованиеЛьготнойСтавки));
		
	КонецЕсли;
	
	Возврат СведенияОСтавкеУСН;

КонецФункции

Функция ПравилаПубликацииСтавкиУСН()
	
	Правила = ПубликацияДанных.НовыеПравилаПубликации();

	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "СтавкаНалога", "rate");
	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "НомерСтатьи", "article");
	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "Пункт", "paragraph");
	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "Подпункт", "subparagraph");
	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "НалоговыеКаникулы", "tax_holiday");
	ПубликацияДанных.ДобавитьПравилоПубликации(Правила, "Период", "date");
	
	Возврат Правила;
	
КонецФункции

#КонецОбласти

#КонецЕсли