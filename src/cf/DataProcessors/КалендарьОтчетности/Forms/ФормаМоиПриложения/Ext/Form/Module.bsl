﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	КлючПароляПользователя = Параметры.КлючПароляПользователя;
	АдресХраненияПароля = Параметры.АдресХраненияПароля;
	
	УстановитьПривилегированныйРежим(Истина);
	ЛогинПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(КлючПароляПользователя) Тогда
		ПодключитьНовыеПриложения();
		ЗаполнитьДоступныеПриложения();
	КонецЕсли;
	
	СтатистикаПоПоказателямКлиентСервер.ДобавитьСобытие("КалендарьОтчетности.ОткрытаФормаНастроек");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(КлючПароляПользователя) Тогда
		// При работе в веб-клиенте следует запросить пароль аутентификации с задержкой, чтобы
		// дать возможность форме отрисоваться. Иначе форма запроса пароля будет показана под
		// формой "Мои приложения".
		ПодключитьОбработчикОжидания("ЗапроситьПарольДляАутентификацииВСервисе", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьСписокПриложений();
	Закрыть(Новый Структура("АдресХраненияПароля, КлючПароляПользователя", АдресХраненияПароля, КлючПароляПользователя));
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСписокПриложений()
	
	// Метод УстановитьСостояние() требует поднятия привилегированного режима, т.к. регистр сведений
	// ОрганизацииОтчетностиОблачныхПриложений является служебным. Поднимем привилегированный режим
	// сразу на всю процедуру, чтобы не делать это в цикле.
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Строка Из ОблачныеПриложения Цикл
		Если Строка.Подключено = Строка.УжеПодключено Тогда
			Продолжить;
		КонецЕсли;
		
		РегистрыСведений.ОрганизацииОтчетностиОблачныхПриложений.УстановитьСостояние(
			ТекущийПользователь,
			Строка.ОрганизацияСсылка,
			Строка.Подключено)
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Строка Из ОблачныеПриложения Цикл
		Строка.Подключено = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьОтметки(Команда)
	
	Для Каждого Строка Из ОблачныеПриложения Цикл
		Строка.Подключено = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапроситьПарольДляАутентификацииВСервисе() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапроситьПарольДляАутентификацииЗавершение", ЭтотОбъект);
	ОткрытьФорму(
		"Обработка.КалендарьОтчетности.Форма.ФормаАутентификации",,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьПарольДляАутентификацииЗавершение(ВведенныйПароль, Контекст) Экспорт
	
	Если Не ЗначениеЗаполнено(ВведенныйПароль) Тогда
		ЗаполнитьДоступныеПриложения();
		Возврат;
	КонецЕсли;
	
	КлючПароляПользователя = СохранитьПарольПользователя(ТекущийПользователь, ВведенныйПароль, АдресХраненияПароля);
	
	ДлительнаяОперация = ПодключитьНовыеПриложения();
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПодключенияПриложений", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Интервал = 1;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Функция ПодключитьНовыеПриложения()
	
	Если Не ЗначениеЗаполнено(КлючПароляПользователя) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПарольПользователя = ПрочитатьПарольПользователя(ТекущийПользователь, КлючПароляПользователя, АдресХраненияПароля);
	ПриложенияПользователя = СообщенияОтчетностиОблачныхПриложений.ДоступныеПриложения(ЛогинПользователя, ПарольПользователя);
	
	Если ПриложенияПользователя = Неопределено Тогда
		// Не удалось получить список приложений. Пользователь ошибся при вводе пароля.
		СообщитьОбОшибкеАутентификации();
		КлючПароляПользователя = "";
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПодключения = СообщенияОтчетностиОблачныхПриложений.НовыйПараметрыПодключенияПриложений();
	ПараметрыПодключения.Пользователь = ТекущийПользователь;
	ПараметрыПодключения.Логин = ЛогинПользователя;
	ПараметрыПодключения.Пароль = ПарольПользователя;
	ПараметрыПодключения.ПриложенияПользователя = ПриложенияПользователя;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"СообщенияОтчетностиОблачныхПриложений.ПодключитьНовыеПриложения",
		ПараметрыПодключения);
	
	Возврат ДлительнаяОперация;
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатПодключенияПриложений(РезультатФормирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатФормирования <> Неопределено Тогда
		ОшибкиПодключения = ПолучитьИзВременногоХранилища(РезультатФормирования.АдресРезультата);
		
		Если ОшибкиПодключения.Количество() Тогда
			СообщитьОбОшибкеПодключения(СтрСоединить(ОшибкиПодключения, ", "));
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДоступныеПриложения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохранитьПарольПользователя(Пользователь, Пароль, Адрес)
	
	ПарольПользователя = ЗашифроватьПароль(Пароль);
	ПоместитьВоВременноеХранилище(ПарольПользователя.ЗашифрованныйПароль, Адрес);
	
	Возврат ПарольПользователя.КлючШифрования;
КонецФункции

&НаСервереБезКонтекста
Функция ПрочитатьПарольПользователя(Пользователь, КлючШифрования, Адрес)
	
	ЗашифрованныйПароль = ПолучитьИзВременногоХранилища(Адрес);
	Пароль = РасшифроватьПароль(ЗашифрованныйПароль, КлючШифрования);
	
	Возврат Пароль;
КонецФункции

&НаСервереБезКонтекста
Функция ЗашифроватьПароль(Пароль)
	
	Результат = Новый Структура("ЗашифрованныйПароль, КлючШифрования", "", "");
	
	ЗашифрованныйПароль = Новый Массив();
	КлючШифрования = Новый Массив();
	ВерхняяГраницаГенератора = 999; // просто случайное число, генератор чисел должен иметь верхнюю границу
	
	Генератор = Новый ГенераторСлучайныхЧисел();
	Для Индекс = 1 По СтрДлина(Пароль) Цикл
		КодСимвола = КодСимвола(Сред(Пароль, Индекс, 1));
		Секрет = Генератор.СлучайноеЧисло(0, ВерхняяГраницаГенератора);
		ЗашифрованныйПароль.Добавить(XMLСтрока(КодСимвола + Секрет));
		КлючШифрования.Добавить(XMLСтрока(Секрет));
	КонецЦикла;
	
	Результат.ЗашифрованныйПароль = СтрСоединить(ЗашифрованныйПароль, РазделительКлючаШифрованияПароля());
	Результат.КлючШифрования = СтрСоединить(КлючШифрования, РазделительКлючаШифрованияПароля());
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция РасшифроватьПароль(ЗашифрованныйПароль, КлючШифрования)
	
	СимволыЗашифрованногоПароля = СтрРазделить(ЗашифрованныйПароль, РазделительКлючаШифрованияПароля());
	СимволыКлючаШифрования = СтрРазделить(КлючШифрования, РазделительКлючаШифрованияПароля());
	
	Пароль = Новый Массив;
	Для Индекс = 0 По СимволыЗашифрованногоПароля.Количество() - 1 Цикл
		КодСимвола = Число(СимволыЗашифрованногоПароля[Индекс]) - Число(СимволыКлючаШифрования[Индекс]);
		Пароль.Добавить(Символ(КодСимвола));
	КонецЦикла;
	
	Возврат СтрСоединить(Пароль, "");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазделительКлючаШифрованияПароля()
	
	// В качестве разделителя возьмем символ стрелки(→).
	Возврат Символ(8594);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДоступныеПриложения()
	
	ОблачныеПриложения.Очистить();
	УстановитьПривилегированныйРежим(Истина);
	Организации = РегистрыСведений.ОрганизацииОтчетностиОблачныхПриложений.Организации(ТекущийПользователь);
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Организация Из Организации Цикл
		НоваяСтрока = ОблачныеПриложения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Организация);
		НоваяСтрока.УжеПодключено = Организация.ВыводитьВКалендарь;
		НоваяСтрока.Подключено = Организация.ВыводитьВКалендарь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СообщитьОбОшибкеПодключения(ИмяПриложения)
	
	ШаблонСообщения = НСтр("ru = 'Не удалось подключить приложение ""%1"". Обратитесь в техническую поддержку.'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ШаблонСообщения, ИмяПриложения));
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщитьОбОшибкеАутентификации()
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Не удалось получить список приложений. Проверьте правильность ввода пароля.'"));
	
КонецФункции

#КонецОбласти
