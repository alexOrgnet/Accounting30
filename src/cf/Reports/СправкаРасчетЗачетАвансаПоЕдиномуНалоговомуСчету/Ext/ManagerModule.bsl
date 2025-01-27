﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	ИмяОтчетаРасчетыПоНалогам = НСтр("ru='Расшифровка расчетов налогов по ЕНС'");
	ПериодОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Организация", ПараметрыОтчета.Организация);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета", ПериодОтчета);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата("39990101000000"));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета", ПериодОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИмяОтчетаРасчетыПоНалогам", ИмяОтчетаРасчетыПоНалогам);
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода); 
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"РуководительДолжность",
		ОтветственныеЛица.РуководительДолжность);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"РуководительПредставление",
		ОтветственныеЛица.РуководительПредставление);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"ТекущаяДата",
		ТекущаяДатаСеанса());
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
		Возврат;
	КонецЕсли;
	
	ПоляРасшифровки = ЭлементРасшифровки.ПолучитьПоля();
	Если ПоляРасшифровки.Количество() > 0 Тогда
		Если ПоляРасшифровки[0].Значение = Null Тогда
			Возврат;
		Иначе
			ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			ПараметрыРасшифровки.Вставить("Значение",      ПоляРасшифровки[0].Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Определяет состав программного интерфейса для интеграции с конфигурацией.
//
// Параметры:
//   Настройки - Структура - Настройки интеграции этого объекта.
//       Описание см. в модуле ПодключаемыеКомандыПереопределяемый,
//       комментарий к процедуре ПриОпределенииСоставаНастроекПодключаемыхОбъектов,
//       раздел "Параметры процедуры ПриОпределенииНастроек"
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;
	
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
	
	Массив.Добавить(Новый Структура("Имя, Представление","СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету", "Зачет аванса по единому налоговому счету"));
	
	Возврат Массив;
	
КонецФункции

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// Возвращаемое значение:
//  Массив - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Наборы = Новый Массив;
	Наборы.Добавить(СправкиРасчетыКлиентСервер.НомерНабораСуммовыхПоказателейПоУмолчанию());
	
	Возврат Наборы;
	
КонецФункции

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	
	Возврат НаборПоказателей;
	
КонецФункции

Функция ПорядокНалоговВОтчетахБП(ВидНалога) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат 10;
	КонецЕсли;
	
	Если ТипЗнч(ВидНалога) = Тип("ПеречислениеСсылка.ВидыНалогов") Тогда
		// Сначала выводим налоги НДФЛ
		НалогиНДФЛ = ЕдиныйНалоговыйСчетПовтИсп.ВсеВидыНалоговНДФЛ();
		Для Каждого ВидНалогаНДФЛ Из НалогиНДФЛ Цикл
			Если Видналога = ВидНалогаНДФЛ.ВидНалога Тогда
				Возврат 1;
			КонецЕсли;
		КонецЦикла;
		Возврат 2;
	КонецЕсли;
	
	Если ТипЗнч(ВидНалога) = Тип("ПеречислениеСсылка.ВидыПлатежейВГосБюджет") Тогда
		// Сначала выводим штрафы, потом пени, потом проценты
		Если Перечисления.ВидыПлатежейВГосБюджет.ЭтоШтраф(ВидНалога)Тогда
			Возврат 3;
		КонецЕсли;
		Если Перечисления.ВидыПлатежейВГосБюджет.ЭтоПени(ВидНалога)Тогда
			Возврат 4;
		КонецЕсли;
		Если Перечисления.ВидыПлатежейВГосБюджет.ЭтоПроценты(ВидНалога)Тогда
			Возврат 5;
		КонецЕсли;
	КонецЕсли;
	
	Возврат 10;
	
КонецФункции

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт
	
	Если Контекст.КлючВарианта = "СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету" Тогда
		Название = Строка(Метаданные.Отчеты.СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету.Синоним);
	ИначеЕсли Контекст.КлючВарианта = "РасшифровкаРасчетовНалоговПоЕНС" Тогда
		Название = "Расчеты по налогам на ЕНС";
	ИначеЕсли Контекст.КлючВарианта = "РасшифровкаЗачетаАвансовНаЕНС" Тогда
		Название = "Зачет авансов по ЕНС";
	Иначе
		Название = Строка(Метаданные.Отчеты.СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету.Синоним);
	КонецЕсли;
	
	ЗаголовокОтчета = Название + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Контекст.НачалоПериода, Контекст.КонецПериода);
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(Контекст.ИдентификаторОтчета, Результат);
	
	// Установим параметры таблицы.
	Результат.ФиксацияСверху = 0;
	Результат.ФиксацияСлева  = 0;
	
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
