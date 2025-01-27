﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьДоступныеЗначения(
		Параметры.Отбор, Параметры.СтрокаПоиска, Параметры.Свойство("ПризнакПлатежногоПоручения")).ДоступныеЗначения;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Отбор") Тогда
		Параметры.Вставить("Отбор", Новый Структура);
	КонецЕсли;
	
	ДанныеВыбора = ПолучитьДоступныеЗначения(
		Параметры.Отбор, Неопределено, Параметры.Свойство("ПризнакПлатежногоПоручения")).ДоступныеЗначения;
	
	Параметры.Отбор.Очистить();
	Параметры.Отбор.Вставить("Ссылка", ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокДоступныхЗначений(Отбор, ЕстьНедоступные = Ложь, ВызовИзПлатежногоПоручения = Ложь) Экспорт
	
	СтруктураДоступныхЗначений = ПолучитьДоступныеЗначения(Отбор, Неопределено, ВызовИзПлатежногоПоручения);
	
	ЕстьНедоступные = СтруктураДоступныхЗначений.ЕстьНедоступные;
	
	Возврат СтруктураДоступныхЗначений.ДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция выполняет заполнение списка значений 
// данных выбора с учетом настроек параметров учета.
// Поддерживается параметр отбора.
// Обрабатывается также строка поиска.
//
Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска, ВызовИзПлатежногоПоручения)
	
	Исключения = Новый Массив;
	
	Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймам);
	
	Организация = Неопределено;
	БанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		Если Отбор.Свойство("Организация") И ЗначениеЗаполнено(Отбор.Организация) Тогда
			Организация = Отбор.Организация;
		КонецЕсли;
		
		Если Отбор.Свойство("СчетОрганизации") И ЗначениеЗаполнено(Отбор.СчетОрганизации) Тогда
			БанковскийСчет = Отбор.СчетОрганизации;
		КонецЕсли;
	КонецЕсли;
	
	// Если отбор не передан, получим значение "по умолчанию", либо "единственную" организацию в ИБ.
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ЭтоЮрЛицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация);
	Иначе
		ЭтоЮрЛицо = Истина; // ИП обычно ведет в базе только себя, а в этом случае организация будет получена.
	КонецЕсли;
	
	Если ВызовИзПлатежногоПоручения Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.СнятиеНаличных);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.КомиссияБанка);
	КонецЕсли;
	
	Валютный = Ложь;
	Если ЗначениеЗаполнено(Организация) Тогда
		Если Не Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация)
			И Не БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям() Тогда
			Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда
			УчетДенежныхСредствБП.УстановитьБанковскийСчет(БанковскийСчет, Организация, Неопределено, Ложь);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(БанковскийСчет) Тогда
			Валютный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "Валютный");
			Если Валютный Тогда
				Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если (НЕ УчетЗарплаты.ИспользуетсяПодсистемаУчетаЗарплатыИКадров()
		ИЛИ (НЕ ЭтоЮрЛицо И НЕ УчетЗарплаты.ИПИспользуетТрудНаемныхРаботников(Организация)))
		ИЛИ Валютный
		Или ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗП);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗаработнойПлатыРаботнику);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДепонентов);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВыдачаЗаймаРаботнику);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеСотрудникуПоДоговоруПодряда);
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеПоИсполнительномуЛистуРаботника);
	КонецЕсли;
	
	Если ЭтоЮрЛицо ИЛИ НЕ ПолучитьФункциональнуюОпцию("ВестиУчетИндивидуальногоПредпринимателя") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ЛичныеСредстваПредпринимателя);
	Иначе
		Исключения.Добавить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов);
	КонецЕсли;
	
	Если ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		Исключения.Добавить(ПеречислениеНалогаЗаТретьихЛиц);
		Исключения.Добавить(ПеречислениеПодотчетномуЛицу);
		Исключения.Добавить(СнятиеНаличных);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВыплатыСамозанятым") Тогда
		Исключения.Добавить(ВыплатыСамозанятым);
		Исключения.Добавить(ВыплатаСамозанятому);
	КонецЕсли;
	
	ДоступныеЗначения = Новый СписокЗначений;
	ЕстьНедоступные   = Ложь;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийСписаниеДенежныхСредств.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И СтрНайти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийСписаниеДенежныхСредств[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийСписаниеДенежныхСредств")
			И Отбор <> Ссылка Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ФиксированныйМассив")
			И Отбор.Найти(Ссылка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Исключения.Найти(Ссылка) <> Неопределено Тогда
			ЕстьНедоступные = Истина;
			Продолжить;
		КонецЕсли;
		ДоступныеЗначения.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
	Возврат Новый Структура("ДоступныеЗначения,ЕстьНедоступные", ДоступныеЗначения, ЕстьНедоступные);
	
КонецФункции

#КонецОбласти

#КонецЕсли