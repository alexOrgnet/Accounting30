﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет, нужен ли для указанного варианта учета счет 40 "Выпуск продукции"
//
// Параметры:
//  ВариантУчета - ПеречислениеСсылка.ВариантыУчетаСтоимостиВыпуска
// 
// Возвращаемое значение:
//  Булево
//
Функция ИспользоватьСчетВыпускПродукции(ВариантУчета) Экспорт
	
	Возврат ВариантУчета = ОтклоненияСтоимости Или ВариантУчета = ПлановаяСтоимость;
	
КонецФункции

// Определяет, нужна ли для указанного варианта учета плановая себестоимость
//
// Параметры:
//  ВариантУчета - ПеречислениеСсылка.ВариантыУчетаСтоимостиВыпуска
// 
// Возвращаемое значение:
//  Булево
//
Функция ИспользоватьПлановуюСебестоимость(ВариантУчета) Экспорт
	
	Возврат ЗначениеЗаполнено(ВариантУчета) И ВариантУчета <> ФактическаяСтоимость;
	
КонецФункции

// Определяет, какой алгоритм используется для учета отклонений фактической стоимости готовой продукции от плановой
// (для варианта учета по фактической стоимости с отражением отклонений от плановой на счете 40).
//
// Транзитный алгоритм - исторически более ранний.
// Он заключается в том, что весь расчет выполняется, как если бы счет 40 не использовался.
// Затем, когда все проводки сформированы, проводки вида Дт 43 Кт 20 механически делятся на две - 
// вставляется транзитный счет 40.
// В результате такого алгоритма оценка запасов будет идентичная, вне зависимости от того, применяется счет 40 или нет.
// Для применения этого алгоритма субконто Продукция на счете 40 не требуется (алгоритмом субконто не используется).
//
// В соответствии с ФСБУ 5 допускается учет продукции по плановой стоимости.
// Как следствие, в этом случае такой алгоритм не применим.
// Для учета по плановой стоимости счет 40 является полноценным центром затрат,
// на котором стоимость выпускаемой продукции учитывается с аналитикой, заданной на этом счете.
// Для применения этого алгоритма на счет 40 добавляется субконто Продукция
//
// На базе этого же алгоритма можно реализовать и учет готовой продукции по фактической стоимости.
// Это позволяет унифицировать алгоритм.
// Однако, это требует заполнения субконто Продукция первичными документами.
// Кроме того, результат применения алгоритма может отличаться от транзитного -
// в тех случаях, когда аналитика на счете 40 обеспечивает меньшую детализацию, чем на счетах прямых расходов.
// Пример таких отличий: выполняются две работы, с одинаковым наименованием, в одном и том же подразделении,
// по одной и той же номенклатурной группе.Однако по одной работе затраты отражены на счете 20, по другой - на счете 23.
// Для транзитного алгоритма стоимость услуг формируется независимо (потому что счет разный),
// а при использовании аналитики на счете 40 стоимость таких услуг будет усреднена.
// Также в частном случае это может привести к диагностике встречного выпуска.
//
// Поэтому в конфигурации транзитный алгоритм применяется, когда нужно сохранить поведение: т.е. для пользователей,
// которые ранее его фактически использовали.
// Для пользователей, которые в новой базе включают применение счета 40, транзитный алгоритм не используется.
// См. также УстановитьТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости и ИспользоватьСубконтоПродукция
//
// Параметры:
//  ВариантУчета - ПеречислениеСсылка.ВариантыУчетаСтоимостиВыпуска
// 
// Возвращаемое значение:
//  Булево - Истина, если в информационной базе может использоваться транзитный алгоритм.
//
Функция ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости(ВариантУчета) Экспорт
	
	Если ВариантУчета <> ОтклоненияСтоимости Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.Ссылка = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВыпускПродукции)
	|	И ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Продукция)
	|	И ХозрасчетныйВидыСубконто.Суммовой";
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

#Область СубконтоПродукция

// Определяет необходимость использования субконто Продукция на счете 40 Выпуск продукции.
//
// Параметры:
//  ВариантУчета - ПеречислениеСсылка.ВариантыУчетаСтоимостиВыпуска
// 
// Возвращаемое значение:
//  Булево - Истина, если субконто следует использовать
//
Функция ИспользоватьСубконтоПродукция(ВариантУчета) Экспорт
	
	Если ВариантУчета = ПлановаяСтоимость Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ВариантУчета <> ОтклоненияСтоимости Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости(ВариантУчета) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Не Константы.ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости.Получить();
	// Субконто может не добавляться для совместимости.
	// Константа обозначает наличие режима совместимости.
	// См. ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости
	
КонецФункции


// Определяет требования к настройке плана счетов исходя из используемого варианта учета.
//
// Параметры:
//  ТребованияУчета - см. ПланыСчетов.Хозрасчетный.НовыйТребованияАналитикиУчета
//  ВариантУчета - ПеречислениеСсылка.ВариантыУчетаСтоимостиВыпуска - используемый вариант учета
//
Процедура ЗаполнитьТребованияАналитикиУчета(ТребованияУчета, ВариантУчета) Экспорт
	
	Если Не ИспользоватьСубконтоПродукция(ВариантУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Требование = ТребованияУчета.Добавить();
	Требование.Счет            = ПланыСчетов.Хозрасчетный.ВыпускПродукции;
	Требование.РазрезАналитики = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Продукция;
	Требование.Суммовой        = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиОбновления

// См. ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости
//
Процедура УстановитьТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК РежимСовместимости
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика.СрезПоследних КАК УчетнаяПолитика
	|ГДЕ
	|	УчетнаяПолитика.УдалитьСпособУчетаВыпускаГотовойПродукции = ЗНАЧЕНИЕ(Перечисление.ВариантыУчетаСтоимостиВыпуска.ОтклоненияСтоимости)";
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Запись = Константы.ТранзитныйАлгоритмУчетаОтклоненийОтПлановойСебестоимости.СоздатьМенеджерЗначения();
	Запись.Прочитать();
	Если Запись.Значение = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Значение = Истина;
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Запись);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
