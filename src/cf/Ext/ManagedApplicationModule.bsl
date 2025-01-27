﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие из КлючИЗначение:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Пример инициализации:
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Пример использования:
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глПодключаемоеОборудованиеСобытиеОбработаноДанные Экспорт; // для целей БГосИС
//Конец РаботаСВнешнимОборудованием

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
#Если МобильныйКлиент Тогда
	Если ОсновнойСерверДоступен() = Ложь Тогда
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	// СтандартныеПодсистемы
#Если МобильныйКлиент Тогда
	Выполнить("СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы()");
#Иначе
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
#КонецЕсли
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
#Если МобильныйКлиент Тогда
	Выполнить("СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы()");
#Иначе
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
#КонецЕсли
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
#Если МобильныйКлиент Тогда
	Выполнить("СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)");
#Иначе
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
#КонецЕсли
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
			Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы
#Если МобильныйКлиент Тогда
	Выполнить("СтандартныеПодсистемыКлиент.ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
		|Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)");
#Иначе
	СтандартныеПодсистемыКлиент.ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
		Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка);
#КонецЕсли
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриВыбореДействияСообщенияСистемыВзаимодействия(Сообщение, Действие)
	
	УведомленияОтФНСАУСНКлиент.ПриВыбореДействияСообщенияСистемыВзаимодействия(Сообщение, Действие);
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// ПодключаемоеОборудование
	ИнтеграцияПодсистемБПОКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ОбработкаПереходаПоНавигационнойСсылке(ДанныеПереходаПоНавигационнойСсылке, СтандартнаяОбработка)
	
	ПараметрыСсылки = ДанныеПереходаПоНавигационнойСсылке.ПараметрыНавигационнойСсылки;
	НавигационнаяСсылка = ДанныеПереходаПоНавигационнойСсылке.ОтносительнаяНавигационнаяСсылка;
	
	// Переход по навигационной ссылке может быть связан с переходом в помощник уплаты налога из Календаря отчетности.
	ИмяКалендаряОтчетности = "ОбработкаКалендарьОтчетности";
	Если СтрНайти(НавигационнаяСсылка, ИмяКалендаряОтчетности)
		И КалендарьОтчетностиКлиент.ВыполненПереходПоНавигационнойСсылке(ПараметрыСсылки) Тогда
		
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

глПодключаемоеОборудованиеСобытиеОбработано = Ложь;

#КонецОбласти