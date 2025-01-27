﻿
// Проверяет строку на соответствие требованиям
//
// Параметры:
//  ПроверяемаяСтрока - Строка - проверяемый строка.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
Функция ТолькоСимволыВСтроке(Знач ПроверяемаяСтрока) Экспорт
	
	Если ПустаяСтрока(ПроверяемаяСтрока) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПроверяемаяСтрока = НРег(СокрЛП(ПроверяемаяСтрока));
	
	// допустимые символы
	СпецСимволы = Спецсимволы();
	
	Если СтрНайти(СпецСимволы, Лев(ПроверяемаяСтрока, 1)) > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// проверяем допустимые символы
	Если Не СтрокаСодержитТолькоДопустимыеСимволы(ПроверяемаяСтрока, СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверяет символ на соответствие требованиям
//
// Параметры:
//  Символ            - Строка - проверяемый символ.
//  ДопустимыеСимволы - Строка - допустимые символы.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
Функция ДопустимыйСимвол(Символ, ДопустимыеСимволы) Экспорт
	
	Если СтрДлина(Символ) = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат СтрНайти(ДопустимыеСимволы, Символ) > 0;
	
КонецФункции

// Возвращает строку спецсимволов
//
// Параметры:
//
// Возвращаемое значение:
//  Строка
//
Функция Спецсимволы() Экспорт
	
	Возврат ".,;:$№#@&_-–+*^=?!'/|\""%()[]{}<> «»`“”";
	
КонецФункции

Функция СтрокаСодержитТолькоДопустимыеСимволы(СтрокаПроверки, ДопустимыеСимволы)
	
	// Проверяем каждый символ в строке - допустим ли он.
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		Символ = Сред(СтрокаПроверки, Индекс, 1);
		ЭтоДопустимыйСимвол =
			СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(Символ)    // Кириллица и ё
			Или СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(Символ) // Латиница
			Или СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ)    // Цифры
			Или ДопустимыйСимвол(Символ, ДопустимыеСимволы);               // Спецсимволы
		
		Если Не ЭтоДопустимыйСимвол Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
