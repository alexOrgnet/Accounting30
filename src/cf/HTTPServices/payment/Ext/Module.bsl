﻿#Область ОбработчикиHTTPМетодов

// Обработчик извещения о платеже от платежной системы.
//
// Параметры:
//	Запрос - HTTPСервисЗапрос - исходный HTTP-запрос
//
// Возвращаемое значение:
//	HTTPСервисОтвет - ответ сервиса
//
Функция payment_notification_post(Запрос)
	
	ПлатежнаяСистема = Запрос.ПараметрыURL["service"];
	
	Если ПлатежнаяСистема = "yookassa" Тогда
		КодОтвета = ОплатаСервисаПлатежнаяСистемаЮKassaБП.НачатьОбработкуОповещенияОПлатеже(Запрос);
		Возврат Ответ(КодОтвета);
	КонецЕсли;
	
	Возврат ОтветОшибка(ОплатаСервисаHTTPБП.КодОтветаНекорректныйЗапрос(),
		"Идентификатор платежной системы некорректный либо отсутствует");
	
КонецФункции

// Метод предназначен для переопределения в расширении конфигурации.
//
// Параметры:
//	Запрос - HTTPСервисЗапрос - исходный HTTP-запрос
//
// Возвращаемое значение:
//	HTTPСервисОтвет - ответ сервиса
//
Функция require_customer_details_get(Запрос)
	
	Возврат Ответ(ОплатаСервисаHTTPБП.КодОтветаНеНайдено());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФукнции

// Возвращает HTTP-ответ с указанным кодом ответа и JSON-телом
// с описанием ошибки.
//
// Параметры:
//	КодОтвета - Число - который нужно установить
//	ОписаниеОшибки - Строка - будет записано в предопредленный элемент text
//
// Возвращаемое значение:
//	HTTPОтвет - сформированный ответ
//
Функция ОтветОшибка(КодОтвета, ОписаниеОшибки = "")

	СтруктураОтвета = Новый Структура;
	
	СтруктураОтвета.Вставить("error", Истина);
	СтруктураОтвета.Вставить("message", ОписаниеОшибки);
	
	Возврат Ответ(КодОтвета, СтруктураОтвета);
	
КонецФункции

// Возвращает HTTP-ответ с указанным кодом ответа и (опционально) JSON-телом
//
// Параметры:
//	КодОтвета - Число - который нужно установить (обычно 200 или 500)
//	СтруктураОтвета - Структура - данные ответа
//	Заголовки - Соответствие - заголовки ответа
//
// Возвращаемое значение:
//	HTTPОтвет - сформированный ответ
//
Функция Ответ(КодОтвета, СтруктураОтвета = Неопределено, Заголовки = Неопределено)
	
	HTTPОтвет = Новый HTTPСервисОтвет(КодОтвета);
	
	Если (СтруктураОтвета <> Неопределено) Тогда
		
		HTTPОтвет.Заголовки["Content-Type"] = "application/json";
		HTTPОтвет.Заголовки["Cache-Control"] = "no-store";
		
		Если ЗначениеЗаполнено(Заголовки) Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(HTTPОтвет.Заголовки, Заголовки, Истина);
		КонецЕсли;
		
		ТелоОтвета = ОплатаСервисаJSONБП.Записать(СтруктураОтвета);
		HTTPОтвет.УстановитьТелоИзСтроки(ТелоОтвета);
		
	КонецЕсли;
	
	Возврат HTTPОтвет;
	
КонецФункции

#КонецОбласти