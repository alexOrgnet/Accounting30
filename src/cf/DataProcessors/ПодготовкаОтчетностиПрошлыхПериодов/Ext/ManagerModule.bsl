﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьОтчеты(Параметры, АдресРезультата) Экспорт
	
	ТаблицаОтчетов = ТаблицаОтчетныхЗадачПрошлыхПериодов(Параметры.Организация);
	
	ОбновитьСведенияОбОтчетах(ТаблицаОтчетов);
	
	ПоместитьВоВременноеХранилище(ТаблицаОтчетов, АдресРезультата);
	
КонецПроцедуры

Функция ПравилоДляПомощникаПодготовкиОтчетности(Организация, НачалоИнтервала = Неопределено, КонецИнтервала = Неопределено) Экспорт
	
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	Если Не ЗначениеЗаполнено(ГраницаОтчетностиПрошлыхПериодов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОтборПравил = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.ОтборПравилЗаполнения();
	ОтборПравил.Организация     = Организация;
	ОтборПравил.НачалоИнтервала = ГраницаОтчетностиПрошлыхПериодов;
	ОтборПравил.КонецИнтервала  = ТекущаяДатаСеанса();
	ОтборПравил.ИмяЗадачи       = КодЗадачиПоУмолчанию(Организация, ГраницаОтчетностиПрошлыхПериодов);
	ОтборПравил.Действие        = Перечисления.ВидыДействийКалендаряБухгалтера.Отчет;
	
	Если ЗначениеЗаполнено(НачалоИнтервала) Тогда
		ОтборПравил.НачалоИнтервала = НачалоИнтервала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонецИнтервала) Тогда
		ОтборПравил.КонецИнтервала = КонецИнтервала;
	КонецЕсли;
	
	Правила = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.НовыйПравилаОрганизации();
	Справочники.ПравилаПредставленияОтчетовУплатыНалогов.ЗаполнитьПравилаОрганизации(Правила, ОтборПравил);
	
	Если Правила.Количество() > 0 Тогда
		Возврат Правила[0].Правило;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура СформироватьОтчеты(Параметры, АдресРезультата) Экспорт
	
	Организация     = Параметры.Организация;
	ТребуемыеОтчеты = Параметры.ТребуемыеОтчеты;
	
	Для Каждого ТребуемыйОтчет Из ТребуемыеОтчеты Цикл
		
		ПараметрыФормирования = ПараметрыФормированияРегламентированногоОтчета(ТребуемыйОтчет, Организация);
		
		Если ТребуемыйОтчет.ИсточникОтчета = "РегламентированныйОтчет3НДФЛ" Тогда
			
			// Для формы отчета 3-НДФЛ формирование декларации по умолчанию  выполняется из формы помощника заполнения
			СформированныйОтчет = Обработки.ПомощникЗаполнения3НДФЛ.СформироватьАвтоматическиРеглОтчет(ПараметрыФормирования);
			
			СтатусОтчета = Новый Структура;
			СтатусОтчета.Вставить("СсылкаНаОбъект", СформированныйОтчет);
			СтатусОтчета.Вставить("Статус", ИнтерфейсыВзаимодействияБРОКлиентСервер.СтатусВРаботеСтрокой());
			ИнтерфейсыВзаимодействияБРО.СохранитьСтатусОтправки(СтатусОтчета);
			
		Иначе
			
			СформированныйОтчет = ИнтерфейсыВзаимодействияБРО.СформироватьАвтоматическиРеглОтчет(
				ТребуемыйОтчет.ИсточникОтчета,
				Организация,
				ТребуемыйОтчет.НачалоПериода,
				ТребуемыйОтчет.КонецПериода,
				Ложь,
				ТребуемыйОтчет.ВыбраннаяФорма,
				ПараметрыФормирования);
			
		КонецЕсли;
		
		Если ПараметрыФормирования.Ошибки.Количество() = 0 Тогда
			
			ТребуемыйОтчет.РегламентированныйОтчет = СформированныйОтчет;
			ТребуемыйОтчет.Статус                  = ИнтерфейсыВзаимодействияБРОКлиентСервер.СтатусВРаботеСтрокой();
			ТребуемыйОтчет.СостояниеСдачиОтчета    = Перечисления.СостояниеСдачиОтчетности.ДокументооборотНеНачат;
			ТребуемыйОтчет.НулеваяДекларация       = ЭтоНулеваяДекларация(СформированныйОтчет);
			ТребуемыйОтчет.СуммаПоДекларации       = ДанныеДекларации(СформированныйОтчет).СуммаНалогаПоДекларации;
			ТребуемыйОтчет.Обновить = Ложь;
			
		Иначе
			
			ТребуемыйОтчет.ОшибкиФормирования = ПараметрыФормирования.Ошибки;
			ТребуемыйОтчет.Обновить = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТребуемыеОтчеты, АдресРезультата);
	
КонецПроцедуры

Функция ОтчетныйПериодДляЗапускаТеста(Правило, Организация) Экспорт
	
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	Если Не ЗначениеЗаполнено(ГраницаОтчетностиПрошлыхПериодов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Нам нужно определить, завершилась ли отчетная компания за период,
	// который предшествует началу работы пользователя в программе.
	// Если не завершилась - то задавать вопрос об этом периоде не имеет смысла.
	// Поэтому берем предыдущий период.
	СрокВыполненияЗадачи = ВыполнениеЗадачБухгалтера.СрокВыполненияЗадачи(
		Организация, Правило, ГраницаОтчетностиПрошлыхПериодов);
	
	Если ЗначениеЗаполнено(СрокВыполненияЗадачи)
		И КонецДня(СрокВыполненияЗадачи) > ТекущаяДатаСеанса() Тогда
		// Срок сдачи отчета еще не истек.
		// Возвращаем предыдущий налоговый период.
		ПериодичностьПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Правило, "Периодичность");
		НачалоПоследнегоОтчетногоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
			ПериодичностьПравила, ГраницаОтчетностиПрошлыхПериодов);
		Возврат НачалоПоследнегоОтчетногоПериода;
	КонецЕсли;
	
	Возврат ГраницаОтчетностиПрошлыхПериодов + 1;
	
КонецФункции

Функция СуммаНалогаПрошлыхЛет(Организация, КодЗадачи) Экспорт
	
	Если ПоддерживаемыеКодыЗадач().Найти(КодЗадачи) = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	ОтчетыПрошлыхПериодов = РегламентированныеОтчетыПрошлыхЛет(Организация);
	
	ОбщаяСуммаНалога = 0;
	Для Каждого ОтчетПрошлогоПериода Из ОтчетыПрошлыхПериодов Цикл
		
		СуммаНалогаПоОтчету = ДанныеДекларации(ОтчетПрошлогоПериода).СуммаНалогаПоДекларации;
		Если СуммаНалогаПоОтчету <> Неопределено Тогда
			ОбщаяСуммаНалога = ОбщаяСуммаНалога + СуммаНалогаПоОтчету;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбщаяСуммаНалога;
	
КонецФункции

Функция СуммыДоходовПрошлыхЛет(Организация, КодЗадачи) Экспорт
	
	Результат = Новый Соответствие;
	
	Если ПоддерживаемыеКодыЗадач().Найти(КодЗадачи) = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОтчетыПрошлыхПериодов = РегламентированныеОтчетыПрошлыхЛет(Организация);
	
	Для Каждого ОтчетПрошлогоПериода Из ОтчетыПрошлыхПериодов Цикл
		ДанныеДекларации = ДанныеДекларации(ОтчетПрошлогоПериода);
		Результат.Вставить(Год(ДанныеДекларации.Период), ДанныеДекларации.СуммаДоходаПоДекларации);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьОбновитьЗадачи(Организация) Экспорт
	
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	Если ГраницаОтчетностиПрошлыхПериодов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеПоОтчетам = РасписаниеПоОтчетам(Организация, ГраницаОтчетностиПрошлыхПериодов);
	
	ДобавитьПризнакПрошлыйПериодПоТесту(Организация, РасписаниеПоОтчетам);
	
	ЗадачиПрошлыхПериодов = ЗадачиПрошлыхПериодов(Организация, ГраницаОтчетностиПрошлыхПериодов);
	
	УдалитьЗадачиВнеРасписания(РасписаниеПоОтчетам, ЗадачиПрошлыхПериодов);
	
	ДобавитьНедостающиеЗадачи(РасписаниеПоОтчетам, ЗадачиПрошлыхПериодов);
	
КонецПроцедуры

// Возвращает актуальное расписание задач по отчетам
//
// Параметры:
//  Организация - СправочникСсылка.Организация - организация для которой нужно расписание
// 
// Возвращаемое значение:
// РасписаниеПоОтчетам - ТаблицаЗначений - см.РегистрСведений.ЗадачиБухгалтера.НовыйРасписание()
//
Функция АктуальноеРасписаниеПоОтчетам(Организация) Экспорт
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);

	Если ГраницаОтчетностиПрошлыхПериодов = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	РасписаниеПоОтчетам = РасписаниеПоОтчетам(Организация, ГраницаОтчетностиПрошлыхПериодов);

	ДобавитьПризнакПрошлыйПериодПоТесту(Организация, РасписаниеПоОтчетам);

	ЗадачиПрошлыхПериодов = ЗадачиПрошлыхПериодов(Организация, ГраницаОтчетностиПрошлыхПериодов);

	УдалитьЗадачиВнеРасписания(РасписаниеПоОтчетам, ЗадачиПрошлыхПериодов);

	ДобавитьНедостающиеЗадачи(РасписаниеПоОтчетам, ЗадачиПрошлыхПериодов);
	
	Возврат РасписаниеПоОтчетам;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СведенияОбОрганизации(Организация, Период) Экспорт
	
	Сведения = НовыйСведенияОбОрганизации();
	Сведения.ДатаНачалаДеятельности = КалендарьБухгалтера.ДатаНачалаДеятельности(Организация);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сведения.ОписаниеОрганизации = НСтр("ru = 'Укажите организацию'");
		Возврат Сведения;
	КонецЕсли;
	
	ДатаНачалаИспользованияЭДО = ИнтерфейсыВзаимодействияБРОВызовСервера.ДатаПодключения1СОтчетности(Организация);
	Сведения.ЭлектронныйДокументооборотДоступен
		= ЗначениеЗаполнено(ДатаНачалаИспользованияЭДО) И ДатаНачалаИспользованияЭДО <= Период;
	
	ЗаполнитьЗначенияСвойств(Сведения, ДанныеГосударственныхОрганов.РеквизитыНалоговогоОрганаПоОрганизации(Организация));
	
	Сведения.ОписаниеОрганизации = Справочники.Организации.ОписаниеОрганизацииДляПомощников(Организация, Период);
	
	Возврат Сведения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодЗадачиПоУмолчанию(Организация, ГраницаОтчетностиПрошлыхПериодов)
	
	Если УчетнаяПолитика.ПлательщикНДФЛ(Организация, ГраницаОтчетностиПрошлыхПериодов) Тогда
		КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиНДФЛПредприниматель();
	Иначе
		КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН();
	КонецЕсли;
	
	Возврат КодЗадачи;
	
КонецФункции

Функция ПоддерживаемыеКодыЗадач()
	
	КодыЗадач = Новый Массив;
	КодыЗадач.Добавить(ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН());
	КодыЗадач.Добавить(ЗадачиБухгалтераКлиентСервер.КодЗадачиНДФЛПредприниматель());
	
	Возврат КодыЗадач;
	
КонецФункции

Функция ТаблицаОтчетныхЗадачПрошлыхПериодов(Организация)
	
	ОтчетныеЗадачи = НоваяТаблицаОтчетныхЗадач();
	
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	Если ГраницаОтчетностиПрошлыхПериодов = Неопределено Тогда
		Возврат ОтчетныеЗадачи;
	КонецЕсли;
	
	ДатаНачалаДеятельности = ГраницаОтчетностиПрошлыхПериодов + 1;
	
	ЗадачиПрошлыхПериодов = ЗадачиПрошлыхПериодов(Организация, ГраницаОтчетностиПрошлыхПериодов);
	ДобавитьПризнакПрошлыйПериодПоТесту(Организация, ЗадачиПрошлыхПериодов);
	
	СвойстваЗадачи = Новый Структура("ИдентификаторЗадачи, ФинансовыйПериод, РасширенныйПервыйНалоговыйПериод");
	
	Для Каждого СтрокаРасписания Из ЗадачиПрошлыхПериодов Цикл
		
		НоваяСтрока = ОтчетныеЗадачи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРасписания);
		
		// Дополнительные сведения о задаче
		НоваяСтрока.НачалоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
			НоваяСтрока.Периодичность, НоваяСтрока.ПериодСобытия);
		НоваяСтрока.КонецПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.КонецПериода(
			НоваяСтрока.Периодичность, НоваяСтрока.ПериодСобытия);
		
		ЗаполнитьЗначенияСвойств(СвойстваЗадачи, СтрокаРасписания);
		
		Если ПомощникиПоУплатеНалоговИВзносов.ЭтоПервыйОтчетныйПериод(Организация, НоваяСтрока.ПериодСобытия, СвойстваЗадачи, ДатаНачалаДеятельности) Тогда
			
			ПропущенныйПериод = ИнтерфейсыВзаимодействияБРО.ПропущенныйНалоговыйПериод(
				СвойстваЗадачи.РасширенныйПервыйНалоговыйПериод,
				Организация,
				ДатаНачалаДеятельности);
			
			Если ЗначениеЗаполнено(ПропущенныйПериод) Тогда
				// Дополним наименование задачи особенностями расширенного отчетного периода.
				МесяцРегистрации = НРег(Формат(ДатаНачалаДеятельности, "Л=ru; ДФ='MMMM yyyy ''г.'''"));
				ДополнениеНаименования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '(включая %1)'"), МесяцРегистрации);
				
				НоваяСтрока.Наименование = НоваяСтрока.Наименование + " " + ДополнениеНаименования;
				
				НоваяСтрока.РасширенныйПериодПодсказка = ПомощникиПоУплатеНалоговИВзносов.ТекстПодсказкиПоРасширенномуПервомуОтчетномуПериоду(
					СвойстваЗадачи.ИдентификаторЗадачи);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Самые актуальные задачи должны оказаться в начале - отчеты в списке показываем "по убыванию".
	ОтчетныеЗадачи.Сортировать("Правило, ПериодСобытия Убыв", Новый СравнениеЗначений);
	
	Возврат ОтчетныеЗадачи;
	
КонецФункции

Функция ДобавитьПризнакПрошлыйПериодПоТесту(Организация, РасписаниеПоОтчетам)
	
	РасписаниеПоОтчетам.Колонки.Добавить("ПрошлыйПериодПоТесту", Новый ОписаниеТипов("Булево"));
	
	ДобавленныеПериодыТестаОтчетности =
		РегистрыСведений.РезультатыПроверкиНалоговОтчетовПрошлыхПериодов.ДобавленныеПериоды(Организация);
	
	Для Каждого СтрокаРасписания Из РасписаниеПоОтчетам Цикл
		
		СтрокаРасписания.ПрошлыйПериодПоТесту = ЭтоОтчетПрошлогоПериодаПоТесту(
			СтрокаРасписания.ПериодСобытия, СтрокаРасписания.Правило, ДобавленныеПериодыТестаОтчетности);
		
	КонецЦикла;
	
КонецФункции

Функция ПериодНалоговПрошлыхПериодов(Организация)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(РезультатыПроверкиНалоговОтчетовПрошлыхПериодов.ПериодСобытия), ДАТАВРЕМЯ(1, 1, 1)) КАК МаксимальныйПериодСобытия,
	|	ЕСТЬNULL(МИНИМУМ(РезультатыПроверкиНалоговОтчетовПрошлыхПериодов.ПериодСобытия), ДАТАВРЕМЯ(1, 1, 1)) КАК МинимальныйПериодСобытия
	|ИЗ
	|	РегистрСведений.РезультатыПроверкиНалоговОтчетовПрошлыхПериодов КАК РезультатыПроверкиНалоговОтчетовПрошлыхПериодов
	|ГДЕ
	|	РезультатыПроверкиНалоговОтчетовПрошлыхПериодов.Организация = &Организация
	|	И РезультатыПроверкиНалоговОтчетовПрошлыхПериодов.ТребуетсяНалогОтчет";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПериодНалогов = Новый Структура;
		
		ПериодНалогов.Вставить("НачалоПериода", Выборка.МинимальныйПериодСобытия);
		ПериодНалогов.Вставить("ОкончаниеПериода", КонецГода(Выборка.МаксимальныйПериодСобытия));
		
		Возврат ПериодНалогов;
	КонецЕсли;
	
	Возврат ПериодНалогов;
	
КонецФункции

Функция ЭтоОтчетПрошлогоПериодаПоТесту(ПериодСобытия, Правило, ДобавленныеПериодыТестаОтчетности)
	
	Отбор = Новый Структура();
	Отбор.Вставить("ПериодСобытия", ПериодСобытия);
	Отбор.Вставить("Правило", Правило);
	Отбор.Вставить("Требуется", Истина);
	
	Возврат ДобавленныеПериодыТестаОтчетности.НайтиСтроки(Отбор).Количество() > 0;
	
КонецФункции

Функция РасписаниеПоОтчетам(Организация, ГраницаОтчетностиПрошлыхПериодов)
	
	ПериодНалоговПрошлыхПериодов = ПериодНалоговПрошлыхПериодов(Организация);
	Если ПериодНалоговПрошлыхПериодов = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаНачалаОбзораПоСрокуДавности = Обработки.МониторНалоговИОтчетности.НачалоОбзораОтчетности(Организация, ТекущаяДатаСеанса());
	
	НачалоОбзора = ?(ЗначениеЗаполнено(ПериодНалоговПрошлыхПериодов.НачалоПериода),
		ПериодНалоговПрошлыхПериодов.НачалоПериода , ДатаНачалаОбзораПоСрокуДавности);
		
	ОтборПравил = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.ОтборПравилЗаполнения();
	ОтборПравил.Организация     = Организация;
	ОтборПравил.НачалоИнтервала = НачалоОбзора;
	ОтборПравил.КонецИнтервала  = ГраницаОтчетностиПрошлыхПериодов + 1;
	ОтборПравил.ИмяЗадачи       = КодЗадачиПоУмолчанию(Организация, ГраницаОтчетностиПрошлыхПериодов);
	ОтборПравил.Действие        = Перечисления.ВидыДействийКалендаряБухгалтера.Отчет;
		
	РасписаниеПоОтчетам = РегистрыСведений.ЗадачиБухгалтера.РасписаниеПоНалогамОтчетамЗаПериод(ОтборПравил);
	
	Возврат РасписаниеПоОтчетам;
	
КонецФункции

Процедура ОбновитьСведенияОбОтчетах(ТаблицаОтчетов)
	
	ЗадачиПоОтчетам = ТаблицаОтчетов.Скопировать(, КлючУникальностиЗадач());
	ВыполнениеЗадач = ВыполнениеЗадачБухгалтера.ВыполнениеЗадачПоПодготовкеОтчетов(ЗадачиПоОтчетам, Истина);
	
	АдминистраторыОтчетов = Новый Соответствие; // Кэш государственных органов.
	
	Для Каждого ОтчетнаяЗадача Из ТаблицаОтчетов Цикл
		
		Отбор = Новый Структура(КлючУникальностиЗадач());
		ЗаполнитьЗначенияСвойств(Отбор, ОтчетнаяЗадача);
		
		НайденныеСтроки  = ВыполнениеЗадач.НайтиСтроки(Отбор);
		СведенияОбОтчете = НайденныеСтроки[0];
		
		ЗаполнитьЗначенияСвойств(ОтчетнаяЗадача, СведенияОбОтчете);
		
		Если СведенияОбОтчете.Документы.Количество() > 0 Тогда
			
			// Созданные отчеты отсортированы по убыванию даты подписи, нам нужен самый последний
			ОтчетнаяЗадача.РегламентированныйОтчет = СведенияОбОтчете.Документы[0].Ссылка;
			ОтчетнаяЗадача.Статус                  = СведенияОбОтчете.Документы[0].Статус;
			ОтчетнаяЗадача.СостояниеСдачиОтчета    = СведенияОбОтчете.Документы[0].СостояниеСдачиОтчетности;
			ОтчетнаяЗадача.НулеваяДекларация       = ЭтоНулеваяДекларация(СведенияОбОтчете.Документы[0].Ссылка);
			ОтчетнаяЗадача.СуммаПоДекларации       = ДанныеДекларации(СведенияОбОтчете.Документы[0].Ссылка).СуммаНалогаПоДекларации;
			
		Иначе
			// Отчет будет создан позже, при обработке задач в форме.
		КонецЕсли;
		
		ОтчетнаяЗадача.ГосударственныйОрган =
			ГосорганАдминистраторОтчета(ОтчетнаяЗадача.ИсточникОтчета, АдминистраторыОтчетов);
		
		Если ОтчетнаяЗадача.ИсточникОтчета = "РегламентированныйОтчет3НДФЛ" Тогда
			// Для формы отчета 3-НДФЛ формирование декларации по умолчанию заполняется из формы помощника заполнения
			ОтчетнаяЗадача.ФормироватьНаКлиенте = Не Обработки.ПомощникЗаполнения3НДФЛ.ФормаЗаполняетсяПомощником(
				ОтчетнаяЗадача.ВыбраннаяФорма);
		Иначе
			// Отчеты, для которых не поддерживается заполнение на сервере,
			// нужно будет создавать на клиенте с получением контекста формы отчета.
			ОперацииСОтчетом = РегламентированнаяОтчетностьКлиентСервер.ОперацииСРегламентированнымОтчетом(
				ОтчетнаяЗадача.ИсточникОтчета, ОтчетнаяЗадача.ВыбраннаяФорма);
			
			ОтчетнаяЗадача.ФормироватьНаКлиенте = (ОперацииСОтчетом.АвтоФормированиеНаСервере <> Истина);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ГосорганАдминистраторОтчета(ИсточникОтчета, АдминистраторыОтчетов)
	
	Госорган = АдминистраторыОтчетов.Получить(ИсточникОтчета);
	
	Если НЕ ЗначениеЗаполнено(Госорган) Тогда
		
		Госорган = ИнтерфейсыВзаимодействияБРО.ВидКонтролирующегоОргана(ИсточникОтчета);
		АдминистраторыОтчетов.Вставить(ИсточникОтчета, Госорган);
		
	КонецЕсли;
	
	Возврат Госорган;
	
КонецФункции

Функция ПараметрыФормированияРегламентированногоОтчета(ТребуемыйОтчет, Организация)
	
	ПараметрыАвтоформирования = ИнтерфейсыВзаимодействияБРО.НовыйПараметрыАвтоформированияОтчета();
	ЗаполнитьЗначенияСвойств(ПараметрыАвтоформирования, ТребуемыйОтчет);
	
	ПараметрыАвтоформирования.Организация    = Организация;
	ПараметрыАвтоформирования.ИмяФормыОтчета = ТребуемыйОтчет.ВыбраннаяФорма;
	ПараметрыАвтоформирования.ДатаНачала     = ТребуемыйОтчет.НачалоПериода;
	ПараметрыАвтоформирования.ДатаОкончания  = ТребуемыйОтчет.КонецПериода;
	
	Если ЗначениеЗаполнено(ТребуемыйОтчет.РегламентированныйОтчет) Тогда
		ПараметрыАвтоформирования.СсылкаНаСохрРеглОтчет = ТребуемыйОтчет.РегламентированныйОтчет;
	КонецЕсли;
	
	Возврат ПараметрыАвтоформирования;
	
КонецФункции

Функция КлючУникальностиЗадач()
	
	Возврат "Организация, ПериодСобытия, Правило, Периодичность, РегистрацияВНалоговомОргане";
	
КонецФункции

Функция НовыйСведенияОбОрганизации()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ДатаНачалаДеятельности", '00010101');
	Результат.Вставить("ОписаниеОрганизации", "");
	Результат.Вставить("ЭлектронныйДокументооборотДоступен", Ложь);
	
	Результат.Вставить("ФНС_Контрагент", Справочники.Контрагенты.ПустаяСсылка());
	Результат.Вставить("ФНС_Наименование", "");
	Результат.Вставить("ФНС_Адрес", "");
	Результат.Вставить("ФНС_Телефоны", "");
	Результат.Вставить("ФНС_СведенияОПолучателеКонверта", Неопределено);
	
	Возврат Результат;
	
КонецФункции

Функция НоваяТаблицаОтчетныхЗадач()
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	// Сведения, описывающие задачу.
	ТаблицаРезультат.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаРезультат.Колонки.Добавить("РегистрацияВНалоговомОргане",
		Новый ОписаниеТипов("СправочникСсылка.РегистрацииВНалоговомОргане"));
	ТаблицаРезультат.Колонки.Добавить("Правило",
		Новый ОписаниеТипов("СправочникСсылка.ПравилаПредставленияОтчетовУплатыНалогов"));
	ТаблицаРезультат.Колонки.Добавить("ПериодСобытия", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ТаблицаРезультат.Колонки.Добавить("Периодичность", Новый ОписаниеТипов("ПеречислениеСсылка.Периодичность"));
	ТаблицаРезультат.Колонки.Добавить("НачалоПериода", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ТаблицаРезультат.Колонки.Добавить("КонецПериода", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ТаблицаРезультат.Колонки.Добавить("Срок", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ТаблицаРезультат.Колонки.Добавить("НачалоВыполнения", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ТаблицаРезультат.Колонки.Добавить("РасширенныйПериодПодсказка", Новый ОписаниеТипов("Строка"));
	ТаблицаРезультат.Колонки.Добавить("ПрошлыйПериодПоТесту", Новый ОписаниеТипов("Булево"));
	
	// Сведения, описывающие исполнение задачи.
	ТаблицаРезультат.Колонки.Добавить("ИсточникОтчета", ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаРезультат.Колонки.Добавить("ВыбраннаяФорма", ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаРезультат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ТаблицаРезультат.Колонки.Добавить("ГосударственныйОрган",
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипыКонтролирующихОрганов"));
	ТаблицаРезультат.Колонки.Добавить("РегламентированныйОтчет",
		Новый ОписаниеТипов("ДокументСсылка.РегламентированныйОтчет"));
	ТаблицаРезультат.Колонки.Добавить("Статус", РегистрыСведений.ЗадачиБухгалтера.ТипСтатуса());
	ТаблицаРезультат.Колонки.Добавить("СтатусУстановленВручную", Новый ОписаниеТипов("Булево"));
	ТаблицаРезультат.Колонки.Добавить("РучнойСтатус", РегистрыСведений.ЗадачиБухгалтера.ТипСтатуса());
	ТаблицаРезультат.Колонки.Добавить("СостояниеСдачиОтчета",
		Новый ОписаниеТипов("ПеречислениеСсылка.СостояниеСдачиОтчетности"));
	ТаблицаРезультат.Колонки.Добавить("НулеваяДекларация", Новый ОписаниеТипов("Булево"));
	ТаблицаРезультат.Колонки.Добавить("СуммаПоДекларации", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	
	ТаблицаРезультат.Колонки.Добавить("ФормироватьНаКлиенте", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаРезультат;
	
КонецФункции

Функция РегламентированныеОтчетыПрошлыхЛет(Организация)
	
	РегламентированныеОтчеты = Новый Массив;
	
	ГраницаОтчетностиПрошлыхПериодов = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	Если ГраницаОтчетностиПрошлыхПериодов = Неопределено Тогда
		Возврат РегламентированныеОтчеты;
	КонецЕсли;
	
	ЗадачиПрошлыхПериодов = ЗадачиПрошлыхПериодов(Организация, ГраницаОтчетностиПрошлыхПериодов);
	ДобавитьПризнакПрошлыйПериодПоТесту(Организация, ЗадачиПрошлыхПериодов);
	
	Отбор = Новый Структура("ПрошлыйПериодПоТесту", Истина);
	ЗадачиПоОтчетам = ЗадачиПрошлыхПериодов.Скопировать(Отбор, КлючУникальностиЗадач());
	ВыполнениеЗадач = ВыполнениеЗадачБухгалтера.ВыполнениеЗадачПоПодготовкеОтчетов(ЗадачиПоОтчетам, Истина);
	
	Для Каждого ВыполненнаяЗадача Из ВыполнениеЗадач Цикл
		Для Каждого СтрокаОтчета Из ВыполненнаяЗадача.Документы Цикл
			РегламентированныеОтчеты.Добавить(СтрокаОтчета.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбщегоНазначенияКлиентСервер.СвернутьМассив(РегламентированныеОтчеты);
	
КонецФункции

#КонецОбласти

#Область ЗадачиПрошлыхПериодов

Функция ЗадачиПрошлыхПериодов(Организация, ГраницаОтчетностиПрошлыхПериодов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГраницаОтчетностиПрошлыхПериодов", ГраницаОтчетностиПрошлыхПериодов);
	Запрос.УстановитьПараметр("КодОсновнойЗадачи", КодЗадачиПоУмолчанию(Организация, ГраницаОтчетностиПрошлыхПериодов));
	Запрос.УстановитьПараметр("Действие", Перечисления.ВидыДействийКалендаряБухгалтера.Отчет);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПравилаПредставленияОтчетовУплатыНалогов.Ссылка КАК Правило,
	|	ЗадачиБухгалтера.Код КАК ИдентификаторЗадачи,
	|	ПравилаПредставленияОтчетовУплатыНалогов.ФинансовыйПериод КАК ФинансовыйПериод,
	|	ПравилаПредставленияОтчетовУплатыНалогов.РасширенныйПервыйНалоговыйПериод КАК РасширенныйПервыйНалоговыйПериод,
	|	ПравилаПредставленияОтчетовУплатыНалогов.Периодичность КАК Периодичность
	|ПОМЕСТИТЬ ВТ_ОсновныеЗадачи
	|ИЗ
	|	Справочник.ЗадачиБухгалтера КАК ЗадачиБухгалтера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаПредставленияОтчетовУплатыНалогов КАК ПравилаПредставленияОтчетовУплатыНалогов
	|		ПО ЗадачиБухгалтера.Ссылка = ПравилаПредставленияОтчетовУплатыНалогов.Владелец
	|ГДЕ
	|	ЗадачиБухгалтера.Код = &КодОсновнойЗадачи
	|	И ПравилаПредставленияОтчетовУплатыНалогов.Действие = &Действие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиБухгалтера.Организация КАК Организация,
	|	ЗадачиБухгалтера.Правило КАК Правило,
	|	ЗадачиБухгалтера.ПериодСобытия КАК ПериодСобытия,
	|	ЗадачиБухгалтера.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ЗадачиБухгалтера.Статус КАК Статус,
	|	ЗадачиБухгалтера.СтатусУстановленВручную КАК СтатусУстановленВручную,
	|	ЗадачиБухгалтера.Статус КАК РучнойСтатус,
	|	ЗадачиБухгалтера.ВАрхиве КАК ВАрхиве,
	|	ЗадачиБухгалтера.Срок КАК Срок,
	|	ЗадачиБухгалтера.НачалоВыполнения КАК НачалоВыполнения,
	|	ВТ_ОсновныеЗадачи.ИдентификаторЗадачи КАК ИдентификаторЗадачи,
	|	ВТ_ОсновныеЗадачи.ФинансовыйПериод КАК ФинансовыйПериод,
	|	ВТ_ОсновныеЗадачи.РасширенныйПервыйНалоговыйПериод КАК РасширенныйПервыйНалоговыйПериод,
	|	ВТ_ОсновныеЗадачи.Периодичность КАК Периодичность,
	|	ЗадачиБухгалтера.Наименование КАК Наименование
	|ИЗ
	|	РегистрСведений.ЗадачиБухгалтера КАК ЗадачиБухгалтера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ОсновныеЗадачи КАК ВТ_ОсновныеЗадачи
	|		ПО ЗадачиБухгалтера.Правило = ВТ_ОсновныеЗадачи.Правило
	|ГДЕ
	|	ЗадачиБухгалтера.Организация = &Организация
	|	И ЗадачиБухгалтера.ПериодСобытия <= &ГраницаОтчетностиПрошлыхПериодов";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура УдалитьЗадачиВнеРасписания(РасписаниеПоОтчетам, СуществующиеЗадачи)
	
	Для Каждого Задача Из СуществующиеЗадачи Цикл
		
		Отбор = Новый Структура("Организация,Правило,ПериодСобытия,РегистрацияВНалоговомОргане");
		ЗаполнитьЗначенияСвойств(Отбор, Задача);
		Отбор.Вставить("ПрошлыйПериодПоТесту", Истина);
		
		СтрокиРасписания = РасписаниеПоОтчетам.НайтиСтроки(Отбор);
		Если СтрокиРасписания.Количество() = 0
			И Задача.Срок <= НачалоГода(ТекущаяДатаСеанса()) Тогда
			// Задачи, срок которых наступает в текущем году не удаляем,
			// т.к. они могли создаваться не в результате теста отчетности прошлых
			// периодов, а штатно при нормальной работе пользователя.
			УдалитьЗадачу(Задача);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьНедостающиеЗадачи(РасписаниеПоОтчетам, СуществующиеЗадачи)
	
	НовыеЗадачи = НовыеЗадачиДляДобавления(РасписаниеПоОтчетам, СуществующиеЗадачи);
	
	ВыполнениеЗадачБухгалтера.ДобавитьСтатусыЗадач(НовыеЗадачи);
	
	// Создадим новые задачи
	Для Каждого Задача Из НовыеЗадачи Цикл
		ДобавитьЗадачу(Задача);
	КонецЦикла;
	
КонецПроцедуры

Функция НовыеЗадачиДляДобавления(РасписаниеПоОтчетам, СуществующиеЗадачи)
	
	НовыеЗадачи = РасписаниеПоОтчетам.СкопироватьКолонки();
	
	Для Каждого ЗадачаПоРасписанию Из РасписаниеПоОтчетам Цикл
		
		Если Не ЗадачаПоРасписанию.ПрошлыйПериодПоТесту Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("Организация,Правило,ПериодСобытия,РегистрацияВНалоговомОргане");
		ЗаполнитьЗначенияСвойств(Отбор, ЗадачаПоРасписанию);
		СтрокиРасписания = СуществующиеЗадачи.НайтиСтроки(Отбор);
		Если СтрокиРасписания.Количество() = 0 Тогда
			ЗаполнитьЗначенияСвойств(НовыеЗадачи.Добавить(), ЗадачаПоРасписанию);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НовыеЗадачи;
	
КонецФункции

Процедура ДобавитьЗадачу(Задача)
	
	Запись = РегистрыСведений.ЗадачиБухгалтера.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Задача);
	Запись.Записать();
	
КонецПроцедуры

Процедура УдалитьЗадачу(Задача)
	
	Запись = РегистрыСведений.ЗадачиБухгалтера.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Задача);
	Запись.Удалить();
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсыВзаимодействияБРО

Функция ЭтоНулеваяДекларация(РегламентированныйОтчет)
	
	Если ТипЗнч(РегламентированныйОтчет) <> Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеДекларации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегламентированныйОтчет, 
		"ИсточникОтчета,ВыбраннаяФорма,ДанныеОтчета,Ссылка");
	
	Если ЗначениеЗаполнено(ДанныеДекларации.ИсточникОтчета)
		И ВРег(ДанныеДекларации.ИсточникОтчета) = ВРег("РегламентированныйОтчетУСН") Тогда
		
		Возврат ДекларацияУСННулевая(ДанныеДекларации);
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеДекларации.ИсточникОтчета)
		И ВРег(ДанныеДекларации.ИсточникОтчета) = ВРег("РегламентированныйОтчет3НДФЛ") Тогда
		
		Возврат Декларация3НДФЛНулевая(ДанныеДекларации);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ДекларацияУСННулевая(ДанныеДекларации)
	
	ДекларацияНулевая = Ложь;
	
	Если ДанныеДекларации.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
		ИЛИ ДанныеДекларации.ВыбраннаяФорма = "ФормаОтчета2014Кв1" Тогда
		
		ДанныеРеглОтчета = ДанныеДекларации.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ДекларацияНулевая;
		КонецЕсли;
		
		ДекларацияДоходыНулевая = Ложь;
		ДекларацияДоходыРасходыНулевая = Ложь;
		
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел21") Тогда
			
			РасчетНалога21 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел21;
			
			КодСтрокиСуммыДоходов = "П002110011303";
			ДекларацияДоходыНулевая = Не ЗначениеЗаполнено(РасчетНалога21[КодСтрокиСуммыДоходов]);
			
		КонецЕсли;
		
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел22") Тогда
			
			РасчетНалога22 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел22;
			
			КодСтрокиСуммыДоходов = "П000220021303";
			
			ДекларацияДоходыРасходыНулевая = ДекларацияНулевая Или Не ЗначениеЗаполнено(РасчетНалога22[КодСтрокиСуммыДоходов]);
			
		КонецЕсли;
		
		ДекларацияНулевая = ДекларацияДоходыНулевая И ДекларацияДоходыРасходыНулевая;
		
	КонецЕсли;
	
	Возврат ДекларацияНулевая;
	
КонецФункции

Функция Декларация3НДФЛНулевая(ДанныеДекларации)
	
	ДанныеРеглОтчета = ДанныеДекларации.ДанныеОтчета.Получить();
	ДанныеОтчета = Отчеты.РегламентированныйОтчет3НДФЛ.ДанныеРеглОтчета(ДанныеДекларации.Ссылка);
	
	Возврат ДанныеОтчета.Итог("Сумма") = 0;
	
КонецФункции

Функция НовыйДанныеДекларации()

	Результат = Новый Структура;
	Результат.Вставить("Период", Дата(1, 1, 1));
	Результат.Вставить("СуммаНалогаПоДекларации" , Неопределено);
	Результат.Вставить("СуммаДоходаПоДекларации" , Неопределено);
	
	Возврат Результат;

КонецФункции

Функция ДанныеДекларации(РегламентированныйОтчет)
	
	Если ТипЗнч(РегламентированныйОтчет) <> Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеДекларации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегламентированныйОтчет, 
		"ИсточникОтчета,ВыбраннаяФорма,ДанныеОтчета,Ссылка,ПометкаУдаления,Дата");
	
	ПроверятьДанныеДекларации = Не ДанныеДекларации.ПометкаУдаления И ЗначениеЗаполнено(ДанныеДекларации.ИсточникОтчета);
	Если ПроверятьДанныеДекларации И ВРег(ДанныеДекларации.ИсточникОтчета) = ВРег("РегламентированныйОтчетУСН") Тогда
		
		Возврат ДанныеДекларацииУСН(ДанныеДекларации);
		
	ИначеЕсли ПроверятьДанныеДекларации И ВРег(ДанныеДекларации.ИсточникОтчета) = ВРег("РегламентированныйОтчет3НДФЛ") Тогда
		
		Возврат ДанныеДекларации3НДФЛ(ДанныеДекларации);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ДанныеДекларацииУСН(ДанныеДекларации)
	
	Результат = НовыйДанныеДекларации();
	Результат.Период = ДанныеДекларации.Дата;
	
	Если ДанныеДекларации.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
		Или ДанныеДекларации.ВыбраннаяФорма = "ФормаОтчета2014Кв1" Тогда
		
		ДанныеРеглОтчета = ДанныеДекларации.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат Результат;
		КонецЕсли;
		
		СуммаНалогаПоДекларации = 0;
		СуммаДоходаПоДекларации = 0;
		
		// Раздел 1.1.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел11") Тогда
			
			НалогКУплате11 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел11;
			
			ПоказателиДляРасчета = Новый Структура;
			ПоказателиДляРасчета.Вставить("П000110002003", 1);
			ПоказателиДляРасчета.Вставить("П000110004003", 1);
			ПоказателиДляРасчета.Вставить("П000110005003", -1);
			ПоказателиДляРасчета.Вставить("П000110007003", 1);
			ПоказателиДляРасчета.Вставить("П000110008003", -1);
			ПоказателиДляРасчета.Вставить("П000110010003", 1);
			ПоказателиДляРасчета.Вставить("П000110011003", -1);
			
			СуммаНалогаПоДекларации = СуммаНалогаПоДекларации + СуммаПоказателей(НалогКУплате11, ПоказателиДляРасчета);
			
		КонецЕсли;
		
		// Раздел 1.2.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел12") Тогда
			
			НалогКУплате12 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел12;
			
			ПоказателиДляРасчета = Новый Структура;
			ПоказателиДляРасчета.Вставить("П000120002003", 1);  // Авансы за 1 квартал
			ПоказателиДляРасчета.Вставить("П000120004003", 1);  // Авансы за 2 квартал
			ПоказателиДляРасчета.Вставить("П000120005003", -1); // Авансы к уменьшению за 2 квартал
			ПоказателиДляРасчета.Вставить("П000120007003", 1);  // Авансы за 3 квартал
			ПоказателиДляРасчета.Вставить("П000120008003", -1); // Авансы к уменьшению за 3 квартал
			ПоказателиДляРасчета.Вставить("П000120010003", 1);  // Налог к доплате за год (за вычетом авансовых платежей)
			ПоказателиДляРасчета.Вставить("П000120011003", -1); // Налог к уменьшению за год
			ПоказателиДляРасчета.Вставить("П000120012003", -1); // Минимальный налог за год
			
			СуммаНалогаПоДекларации = СуммаНалогаПоДекларации + СуммаПоказателей(НалогКУплате12, ПоказателиДляРасчета);
			
		КонецЕсли;
		
		// Раздел 2.1.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел21") Тогда
			
			РасчетНалога21 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел21;
			
			ПоказателиДляРасчета = Новый Структура;
			Если ДанныеДекларации.ВыбраннаяФорма = "ФормаОтчета2015Кв1" Тогда
				ПоказателиДляРасчета.Вставить("П002110011303", 1);
			Иначе
				ПоказателиДляРасчета.Вставить("П000210011303", 1);
			КонецЕсли;
			
			СуммаДоходаПоДекларации = СуммаДоходаПоДекларации + СуммаПоказателей(РасчетНалога21, ПоказателиДляРасчета);
			
		КонецЕсли;
		
		// Раздел 2.2.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел22") Тогда
			
			РасчетНалога22 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел22;
			
			ПоказателиДляРасчета = Новый Структура;
			ПоказателиДляРасчета.Вставить("П000220021303", 1);
			
			СуммаДоходаПоДекларации = СуммаДоходаПоДекларации + СуммаПоказателей(РасчетНалога22, ПоказателиДляРасчета);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.СуммаНалогаПоДекларации = СуммаНалогаПоДекларации;
	Результат.СуммаДоходаПоДекларации = СуммаДоходаПоДекларации;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеДекларации3НДФЛ(ДанныеДекларации)
	
	Результат = НовыйДанныеДекларации();
	Результат.Период = ДанныеДекларации.Дата;
	
	ДанныеРеглОтчета = ДанныеДекларации.ДанныеОтчета.Получить();
	ДанныеОтчета = Отчеты.РегламентированныйОтчет3НДФЛ.ДанныеРеглОтчета(ДанныеДекларации.Ссылка);
	
	Результат.СуммаНалогаПоДекларации = ДанныеОтчета.Итог("Сумма");
	
	Возврат Результат;
	
КонецФункции

Функция СуммаПоказателей(Показатели, ПоказателиДляРасчета)
	
	СуммаПоказателей = 0;
	Для Каждого Показатель Из ПоказателиДляРасчета Цикл
		СуммаПоказателей = СуммаПоказателей +
			Показатели[Показатель.Ключ] * Показатель.Значение;
		КонецЦикла;
	Возврат СуммаПоказателей;
	
КонецФункции

#КонецОбласти

#КонецЕсли