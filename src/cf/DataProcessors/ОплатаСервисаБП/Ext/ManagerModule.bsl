﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует значение параметра сеанса ВыбранныйТариф как пустую строку.
// Непустое значение параметра устанавливается в результате интерактивной работы пользователя в сеансе.
//
// Подробнее см. СтандартныеПодсистемыСервер.УстановкаПараметровСеанса()
//
Процедура УстановитьВыбранныйТариф(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	Если ИмяПараметра = "ВыбранныйТариф" Тогда
		
		ПараметрыСеанса.ВыбранныйТариф = "";
		УстановленныеПараметры.Добавить(ИмяПараметра);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет доступность оплаты сервиса, выводит в интерфейс обработку оплаты.
//
Процедура НастроитьИнтерфейсОплатыСервиса(ДоступнаОплата) Экспорт
	
	НаборКонстант = Константы.СоздатьНабор("ИнтерфейсТакси, ИнтерфейсТаксиПростой");
	НаборКонстант.Прочитать();
	
	Если ДоступнаОплата Тогда
		Константы.ОплатаПолныйИнтерфейс.Установить(НаборКонстант.ИнтерфейсТакси);
		Константы.ОплатаПростойИнтерфейс.Установить(НаборКонстант.ИнтерфейсТаксиПростой);
	Иначе
		Константы.ОплатаПростойИнтерфейс.Установить(Ложь);
		Константы.ОплатаПолныйИнтерфейс.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие возможности оплаты сервиса
// 
// Возвращаемое значение:
//  Булево - Истина, если пользователь может оплатить сервис
//
Функция ДоступнаОплатаСервиса() Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДоступностьПоФункциональнымОпциям = ПолучитьФункциональнуюОпцию("ОплатаПолныйИнтерфейс")
		Или ПолучитьФункциональнуюОпцию("ОплатаПростойИнтерфейс");
	
	Возврат ДоступностьПоФункциональнымОпциям И Пользователи.ЭтоПолноправныйПользователь();
	
КонецФункции

#КонецОбласти

#КонецЕсли
