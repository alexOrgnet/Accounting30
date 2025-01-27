﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Включает чек в регистр: устанавливает отметку о том, что чек был отсканирован пользователем
//
// Параметры:
//  КассовыйЧек - ДокументСсылка.КассовыйЧекПодотчетногоЛица
//  Пользователь - ОпределяемыйТип.ПользовательШиныМобильныхПриложений - пользователь, отсканировавший чек
//               - Неопределено - текущий пользователь отсканировал чек
//
Процедура Включить(КассовыйЧек, Знач Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	// Все чеки необходимо регистрировать.
	// Регистрация производится при записи документа КассовыйЧекПодотчетногоЛица.
	// Любой документ, полученный от мобильного приложения, подключенного по логину и паролю, записывается дважды:
	// 1. При получении на обработку через HTTP-сервис. Срабатывает механизм "Клиентского приложения", работающий
	// анонимно (без привязки к какому-то пользователю ИБ или физическому лицу). В этом случае не нужно ничего регистрировать,
	// пользователем будет строковый идентификатор "Клиентского приложения".
	// 2. При получении детализации чека, когда пользователь зашел интерактивно в Авансовые отчеты. В этом случае уже
	// произойдет регистрация чека под текущим пользователем.
	// Для аппаратного сканера регистрация выполняется сразу, т.к. происходит от имени текущего пользователя, отсканировавшего чек.
	Если Не ЗначениеЗаполнено(Пользователь) Или
		Не Метаданные.ОпределяемыеТипы.ПользовательШиныМобильныхПриложений.Тип.СодержитТип(ТипЗнч(Пользователь)) Тогда
			Возврат;
	КонецЕсли;
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.КассовыйЧек  = КассовыйЧек;
	Запись.Пользователь = Пользователь;
	Запись.Записать();
	
КонецПроцедуры

// Исключает чек из регистра: удаляет отметку о том, что чек был отсканирован пользователем
//
// Параметры:
//  КассовыйЧек - ДокументСсылка.КассовыйЧекПодотчетногоЛица
//  Пользователь - ОпределяемыйТип.ПользовательШиныМобильныхПриложений
//
Процедура Исключить(КассовыйЧек, Пользователь) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.КассовыйЧек  = КассовыйЧек;
	Запись.Пользователь = Пользователь;
	Запись.Удалить();
	
КонецПроцедуры

// Проверяет, что чек отсканирован указанным пользователем.
//
// Параметры:
//  КассовыйЧек - ДокументСсылка.КассовыйЧекПодотчетногоЛица
//  Пользователь - ОпределяемыйТип.ПользовательШиныМобильныхПриложений
// 
// Возвращаемое значение:
//  Булево - Истина, если в регистре есть запись, что чек отсканирован указанным пользователем
//
Функция НайтиЧекПользователя(КассовыйЧек, Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КассовыйЧек",  КассовыйЧек);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сканирование.КассовыйЧек КАК КассовыйЧек
	|ИЗ
	|	РегистрСведений.СканированиеКассовыхЧековПодотчетныхЛиц КАК Сканирование
	|ГДЕ
	|	Сканирование.КассовыйЧек = &КассовыйЧек
	|	И Сканирование.Пользователь = &Пользователь";
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Возвращает пользователя, который отсканировал чек.
//
// Параметры:
//  КассовыйЧек - ДокументСсылка.КассовыйЧекПодотчетногоЛица
// 
// Возвращаемое значение:
//  Пользователь - ОпределяемыйТип.ПользовательШиныМобильныхПриложений,
//  Неопределено - если запись для чека отсутствует
//
Функция ПользовательЧека(КассовыйЧек) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КассовыйЧек",  КассовыйЧек);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сканирование.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СканированиеКассовыхЧековПодотчетныхЛиц КАК Сканирование
	|ГДЕ
	|	Сканирование.КассовыйЧек = &КассовыйЧек";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Пользователь;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Позволяет при записи чека установить отметку, что он был отсканирован текущим пользователем.
// Непосредственно отметка записывается в транзакции записи документа - для этого в обработчике ПриЗаписи
// должен быть вызван метод ВключитьОбъект
//
// Параметры:
//  КассовыйЧекОбъект - ДокументОбъект.КассовыйЧекПодотчетногоЛица - записываемый чек
//
Процедура УстановитьТекущийПользовательОтсканировалЧек(КассовыйЧекОбъект) Экспорт
	
	КассовыйЧекОбъект.ДополнительныеСвойства.Вставить("ПользовательОтсканировалЧек", Пользователи.ТекущийПользователь());
	
КонецПроцедуры

// Позволяет при записи чека установить отметку, что он был отсканирован пользователем шины мобильных приложений.
// Непосредственно отметка записывается в транзакции записи документа - для этого в обработчике ПриЗаписи
// должен быть вызван метод ВключитьОбъект
//
// Параметры:
//  КассовыйЧекОбъект - ДокументОбъект.КассовыйЧекПодотчетногоЛица - записываемый чек
//  ПользовательШины - ОпределяемыйТип.ПользовательШиныМобильныхПриложений
//
Процедура УстановитьПользовательШиныОтсканировалЧек(КассовыйЧекОбъект, ПользовательШины) Экспорт
	
	КассовыйЧекОбъект.ДополнительныеСвойства.Вставить(
		"ПользовательШиныМобильныхПриложенийОтсканировалЧек",
		ПользовательШины);
	
КонецПроцедуры

// Включает записываемый чек (объект) в регистр.
// Объект должен быть подготовлен с помощью УстановитьТекущийПользовательОтсканировалЧек
// или УстановитьПользовательШиныОтсканировалЧек
//
// Параметры:
//  КассовыйЧекОбъект - ДокументОбъект.КассовыйЧекПодотчетногоЛица - записываемый чек
//
Процедура ВключитьОбъект(КассовыйЧекОбъект) Экспорт
	
	Если КассовыйЧекОбъект.ДополнительныеСвойства.Свойство("ПользовательОтсканировалЧек") Тогда
		Включить(
			КассовыйЧекОбъект.Ссылка,
			КассовыйЧекОбъект.ДополнительныеСвойства.ПользовательОтсканировалЧек);
	ИначеЕсли КассовыйЧекОбъект.ДополнительныеСвойства.Свойство("ПользовательШиныМобильныхПриложенийОтсканировалЧек") Тогда
		Включить(
			КассовыйЧекОбъект.Ссылка,
			КассовыйЧекОбъект.ДополнительныеСвойства.ПользовательШиныМобильныхПриложенийОтсканировалЧек);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
