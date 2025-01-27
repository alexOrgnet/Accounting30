﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возникает при запуске приложения до открытия главного окна. 
// В процедуре-обработчике могут быть выполнены необходимые проверки и, при необходимости, установлен параметр отказа 
// от запуска приложения. Соответствует обработчику ПередНачаломРаботыСистемы.
//
// При работе в модели сервиса обработчик вызывается также:
// - при запуске сеанса администратора без установленных значений разделителей;
// - при входе администратора в область данных из сеанса без установленных значений разделителей.
// Для проверки режима запуска см. функцию ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных.
//
// Параметры:
//  Параметры - Структура:
//   * Отказ         - Булево - возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - возвращаемое значение. Если установить Истина, и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
// 
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - возвращаемое значение. Имеет смысл, когда Отказ
//                              и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - возвращаемое значение. Для открытия окна, блокирующего вход в
//                              программу, следует присвоить в этот параметр описание обработчика
//                              оповещения, который открывает окно. 
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в обработке
//                              закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения. 
//
//   * Модули                 - Массив - ссылки на модули, в которых нужно вызвать эту же процедуру после возврата.
//                              Модули можно добавлять только в рамках вызова в процедуру переопределяемого модуля.
//                              Используется для упрощения реализации нескольких последовательных асинхронных вызовов
//                              в разные подсистемы. См. пример ИнтеграцияПодсистемБСПКлиент.ПередНачаломРаботыСистемы.
//
// Пример:
//  Следующий код открывает окно, блокирующее вход в программу.
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.Свойство("ТребуетсяПерезапуск") И ПараметрыРаботыКлиента.ТребуетсяПерезапуск Тогда
		Параметры.Отказ = Истина;
		Параметры.Перезапустить = Истина;
	ИначеЕсли ПараметрыРаботыКлиента.ПоказатьПомощникПереходаСРедакции20 Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьПомощникПереходаСРедакции20", ОбщегоНазначенияБПКлиент);
	КонецЕсли;
	
	// ЗарплатаКадры
	ЗарплатаКадрыКлиент.ПередНачаломРаботыСистемы(Параметры);
	// Конец ЗарплатаКадры 
	
	//ПодключаемоеОборудование
	ИнтеграцияПодсистемБПОКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

// Возникает при запуске приложения после открытия главного окна. 
// В процедуре-обработчике могут быть выполнены различные действия, необходимые при запуске программы, например, 
// открыты некоторые формы. Соответствует обработчику ПриНачалеРаботыСистемы.
//
// При работе в модели сервиса обработчик вызывается также:
// - при запуске сеанса администратора без установленных значений разделителей;
// - при входе администратора в область данных из сеанса без установленных значений разделителей.
// Для проверки режима запуска см. функцию ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных.
//
// Параметры:
//  Параметры - Структура:
//   * Отказ         - Булево - возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - возвращаемое значение. Если установить Истина и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
//
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - возвращаемое значение. Имеет смысл
//                              когда Отказ и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - возвращаемое значение. Для открытия окна, блокирующего вход
//                              в программу, следует присвоить в этот параметр описание обработчика оповещения,
//                              который открывает окно. См. пример в ПередНачаломРаботыСистемы.
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в
//                              обработке закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения.
//                              
//   * Модули                 - Массив - ссылки на модули, в которых нужно вызвать эту же процедуру после возврата.
//                              Модули можно добавлять только в рамках вызова в процедуру переопределяемого модуля.
//                              Используется для упрощения реализации нескольких последовательных асинхронных вызовов
//                              в разные подсистемы. См. пример ИнтеграцияПодсистемБСПКлиент.ПередНачаломРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.Свойство("ЗаблокироватьПриложение") Тогда
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ЗавершениеРаботыСистемы", ОбщегоНазначенияБПКлиент),
			ПараметрыРаботыКлиента.ЗаблокироватьПриложение);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("СообщитьОРекомендуемойВерсииПлатформы")
			И ПараметрыРаботыКлиента.СообщитьОРекомендуемойВерсииПлатформы = Истина
			И Параметры.ИнтерактивнаяОбработка = Неопределено Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПоказатьРекомендуемуюВерсиюПлатформы", ОбщегоНазначенияБПКлиент);
	КонецЕсли;
	
	// ЗарплатаКадры
	ЗарплатаКадрыКлиент.ПриНачалеРаботыСистемы(Параметры);
	// Конец ЗарплатаКадры  
	
	//ПодключаемоеОборудование
	ИнтеграцияПодсистемБПОКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

// Вызывается для обработки собственных параметров запуска программы,
// передаваемых с помощью ключа командной строки /C, например: 
// 1cv8.exe /C РежимОтладки;ОткрытьИЗакрыть
//
// Параметры:
//  ПараметрыЗапуска  - Массив из Строка - строки, разделенные символом ";" в параметре запуска,
//                      которые переданы в конфигурацию с помощью ключа командной строки /C.
//  Отказ             - Булево - если установить Истина, то запуск будет прерван.
//
Процедура ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ) Экспорт
	
КонецПроцедуры

// Выполняется при запуске приложения после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует размещать код в процедуре ПриНачалеРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		// Собор статистики по системам налогообложения организаций
		ПодключитьОбработчикОжидания("Подключаемый_ДобавитьСтатистикуПоСНООрганизаций", 0.1, Истина);
		
		Если ПараметрыРаботыКлиента.Свойство("ИспользуетсяНедоступныйВидОрганизации") Тогда
			ОткрытьФорму("Справочник.Организации.Форма.ИспользуетсяНедоступнаяФункциональность");
			// Если используется недоступная функциональность, то ничего больше не показываем - только окно недоступной функциональности.
			Возврат;
		КонецЕсли;
		
		Если ПараметрыРаботыКлиента.Свойство("ИспользуетсяНедоступнаяСистемаНалогообложения") Тогда
			ОткрытьФорму("РегистрСведений.НастройкиСистемыНалогообложения.Форма.ИспользуетсяНедоступнаяФункциональность");
			// Если используется недоступная функциональность, то ничего больше не показываем - только окно недоступной функциональности.
			Возврат;
		КонецЕсли;
		
		Если ПараметрыРаботыКлиента.Свойство("ИспользуетсяНедоступнаяФункциональность") Тогда
			ФункциональностьПрограммыКлиент.ПоказатьПредупреждениеОбИспользованииНедоступнойФункциональности(
				ПараметрыРаботыКлиента);
			// Если используется недоступная функциональность, то ничего больше не показываем - только окно недоступной функциональности.
			Возврат;
		КонецЕсли;
		
		ИнтерфейсОбновлен = Ложь;
		
		// В чистой базе устанавливается специальный интерфейс начала работы.
		РежимНачалаРаботы = "";
		Если ПараметрыРаботыКлиента.Свойство("АктивироватьПрограмму")
			Или ПараметрыРаботыКлиента.ПоказыватьБыстрыйСтарт Тогда
			
			НачальноеЗаполнениеВызовСервера.ПодготовитьДанныеДляЗаполненияПриложения();

			РежимНачалаРаботы = ?(ПараметрыРаботыКлиента.Свойство("АктивироватьПрограмму"), "АктивацияПрограммы", "БыстрыйСтарт");
			ОбщегоНазначенияБПВызовСервера.УстановитьИнтерфейсНачалаРаботы(РежимНачалаРаботы);
			Если Не ПараметрыРаботыКлиента.Свойство("СкрытьРабочийСтолПриНачалеРаботыСистемы") Тогда
				ОбновитьИнтерфейс();
				ИнтерфейсОбновлен = Истина;
			КонецЕсли;
			
		// Иначе отображается монитор интернет-поддержки, очень важные новости,
		// а также в режиме интеграции с банком устанавливается стандартный интерфейс.
		Иначе
			
			// ИнтернетПоддержкаПользователей
			ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы(Неопределено);
			// Конец ИнтернетПоддержкаПользователей
			
		КонецЕсли;
		
		ДокументооборотСКОКлиент.ПослеЗапускаСистемы();
		ФинОтчетностьВБанкиКлиент.ПослеЗапускаСистемы();
		
		// 1. Регистрация, путеводители, справочная информация
		
		Если Не ЗначениеЗаполнено(РежимНачалаРаботы)
			И ПараметрыРаботыКлиента.Свойство("ОткрытьМониторНалоговИОтчетности") 
			И ПараметрыРаботыКлиента.ОткрытьМониторНалоговИОтчетности Тогда
			
			ОбщегоНазначенияБПКлиент.ОткрытьМониторНалоговИОтчетности();
			
		ИначеЕсли ПараметрыРаботыКлиента.Свойство("ПоказыватьБыстрыйСтартПриРегистрации") 
			И ПараметрыРаботыКлиента.ПоказыватьБыстрыйСтартПриРегистрации Тогда
			
			Если ПараметрыРаботыКлиента.Свойство("ПараметрыБыстрогоСтартаПриРегистрации") Тогда
				ОбщегоНазначенияБПКлиент.ОткрытьБыстрыйСтарт(
					ПараметрыРаботыКлиента.ПараметрыБыстрогоСтартаПриРегистрации);
			Иначе
				ОбщегоНазначенияБПКлиент.ОткрытьБыстрыйСтарт();
			КонецЕсли;
			
		ИначеЕсли ПараметрыРаботыКлиента.Свойство("ОткрытьПомощникРегистрации") 
			И ПараметрыРаботыКлиента.ОткрытьПомощникРегистрации Тогда
			
			ОбщегоНазначенияБПКлиент.ОткрытьРегистрацияОрганизации(ПараметрыРаботыКлиента.НавигацияНомерШага);
			
			Если ПараметрыРаботыКлиента.ПоказатьНачалоРаботыВСервисе Тогда
				// Ссылки на основные разделы программы для предпринимателей в сервисе
				ОбщегоНазначенияБПКлиент.ОткрытьНачалоРаботыВСервисе();
			КонецЕсли;
			
		ИначеЕсли ПараметрыРаботыКлиента.Свойство("ОткрытьПомощникВнесенияИзменений") 
			И ПараметрыРаботыКлиента.ОткрытьПомощникВнесенияИзменений Тогда
			
			ОбщегоНазначенияБПКлиент.ОткрытьПомощникВнесенияИзменений(ПараметрыРаботыКлиента.НавигацияНомерШага);
			
			Если ПараметрыРаботыКлиента.ПоказатьНачалоРаботыВСервисе Тогда
				// Ссылки на основные разделы программы для предпринимателей в сервисе
				ОбщегоНазначенияБПКлиент.ОткрытьНачалоРаботыВСервисе();
			КонецЕсли;
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
			
			// При обновлении версии открываем только описание изменений, 
			// если не выполняется процесс регистрации организации.
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьНачалоРаботыВСервисе
			И НЕ ПараметрыРаботыКлиента.Свойство("АктивироватьПрограмму")
			И НЕ ПараметрыРаботыКлиента.ПоказыватьБыстрыйСтарт Тогда
			
			// Ссылки на основные разделы программы для предпринимателей в сервисе
			ОбщегоНазначенияБПКлиент.ОткрытьНачалоРаботыВСервисе();
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьЗнакомствоСРедакциейВ30 Тогда
			
			// Знакомство с редакцией 3.0
			ОбщегоНазначенияБПКлиент.ОткрытьНачинаемРаботатьВ30(ПараметрыРаботыКлиента.ИмяОбработкиЗнакомствоСРедакциейВ30);
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьПутеводительПоДемоБазе Тогда
			
			// Путеводитель по демо-базе
			ОбщегоНазначенияБПКлиент.ОткрытьПутеводительПоДемоБазеПриЗапуске();
			
		КонецЕсли;
		
		// 2. Окна, которые требуют от пользователя каких-либо действий
		
		Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
			
			// При обновлении версии открываем только описание изменений,
			// если не выполняется процесс регистрации организации.
		
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьСвертку Тогда
			
			// Свертка базы (продолжение работы)
			ОбщегоНазначенияБПКлиент.ОткрытьСверткуБазы();
			
		ИначеЕсли ПараметрыРаботыКлиента.ФормированиеОстатковПоНДС Тогда 
			
			// Открытие формы "Налоги и отчеты" для формирования остатков,
			// необходимых для начала ведения раздельного учета НДС.
			// Форма открывается при включении раздельного учета НДС в Простом интерфейсе,
			// после перезапуска приложения.
			ОбщегоНазначенияБПКлиент.ОткрытьНалогиИОтчетыДляФормированияОстатковПоНДС(ПараметрыРаботыКлиента);
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьПредложитьОбновитьВерсиюПрограммы Тогда
			
			// Информация о необходимости обновить конфигурацию
			ОбщегоНазначенияБПКлиент.ПредупредитьОНеобходимостиОбновленияПрограммы(ПараметрыРаботыКлиента);
			
		ИначеЕсли ПараметрыРаботыКлиента.ПоказатьВключитьОсновнойИнтерфейс Тогда
			
			// Предложение включить основной интерфейс
			ОбщегоНазначенияБПКлиент.ПредложитьИспользоватьОсновнойИнтерфейс(
				ПараметрыРаботыКлиента.ВариантПредложенияВключитьОсновнойИнтерфейс);
			
		КонецЕсли;
		
		Если ПараметрыРаботыКлиента.Свойство("ПоказатьПомощникИсключенияИзПрослеживаемости") Тогда
			ОбщегоНазначенияБПКлиент.ОткрытьФормуПомощникаИсключенияИзПрослеживаемости(ПараметрыРаботыКлиента.ПоказатьПомощникИсключенияИзПрослеживаемости);
		КонецЕсли;
		
		Если Не ИнтерфейсОбновлен
			И ПараметрыРаботыКлиента.Свойство("ОбновитьИнтерфейс")
			И ПараметрыРаботыКлиента.ОбновитьИнтерфейс Тогда
			ОбновитьИнтерфейс();
		КонецЕсли;
		
		НадежностьБанковКлиент.ПослеНачалаРаботыСистемы();
		
		ЗаявкиНаКредитКлиент.ПослеНачалаРаботыСистемы();
		
		ЗаявкиНаОткрытиеСчетаКлиент.ПослеНачалаРаботыСистемы();

		ОповещенияПлатформыСамозанятыеКлиент.ПослеНачалаРаботы();
		
		УведомленияОтФНСАУСНКлиент.ПослеНачалаРаботы();
		
		ЭлектронноеВзаимодействиеКлиент.ПослеНачалаРаботыСистемы();
		
		ИнтеграцияИСМПКлиент.ПодключитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
		
		РегламентированнаяОтчетностьКлиент.ПослеНачалаРаботыСистемы();
		
		// ИнтеграцияС1СДокументооборотом
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
			МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
				"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
			МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПослеНачалаРаботыСистемы();
		КонецЕсли;
		// Конец ИнтеграцияС1СДокументооборотом
		
		// РекламныйСервис
		РекламныйСервисКлиент.ПослеНачалаРаботыСистемы();
		// Конец РекламныйСервис
		
	КонецЕсли;
	
КонецПроцедуры

// Возникает перед завершением работы приложения до закрытия главного окна. 
// В процедуре-обработчике могут быть выполнены необходимые проверки и, при необходимости, может быть установлен 
// параметр отказа от выхода из программы. 
// Позволяет определить список предупреждений, выводимых пользователю перед завершением работы.
// В процессе завершения работы приложения запрещены серверные вызовы и  открытие окон. 
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
//
// При работе в модели сервиса обработчик вызывается также:
// - при завершении сеанса администратора без установленных значений разделителей;
// - при выходе администратора из области данных в сеанса без установленных значений разделителей.
// Для проверки режима запуска см. функцию ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных.
//
// Параметры:
//  Отказ          - Булево - если установить данному параметру значение Истина, то работа с программой не будет 
//                            завершена.
//  Предупреждения - Массив из см. СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы - 
//                            можно добавить сведения о внешнем виде предупреждения и дальнейших действиях.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

// Позволяет переопределить заголовок приложения.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка приложения;
//  ПриЗапуске          - Булево - Истина, если вызывается при начале работы приложения.
//                                 В этом случае недопустимо вызывать те серверные функции конфигурации,
//                                 которые рассчитывают на то, что запуск уже полностью завершен. 
//                                 Например, вместо СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента
//                                 следует вызывать СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске. 
//
// Пример:
//  Для того чтобы в начале заголовка приложения вывести название текущего проекта, следует определить параметр 
//  ТекущийПроект в процедуре ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента и вписать код:
//
//	Если Не ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных() Тогда
//		Возврат;
//	КонецЕсли;
//	ПараметрыКлиента = ?(ПриЗапуске, СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
//		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента());
//	Если ПараметрыКлиента.Свойство("ТекущийПроект")
//	   И ЗначениеЗаполнено(ПараметрыКлиента.ТекущийПроект) Тогда
//		ЗаголовокПриложения = Строка(ПараметрыКлиента.ТекущийПроект) + " / " + ЗаголовокПриложения;
//	КонецЕсли;
//
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
	ПараметрыКлиента = ?(ПриЗапуске, СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента());
	
	ПараметрыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		ПредставлениеЗаголовка = ПараметрыКлиента.ЗаголовокПриложения;
		ПредставлениеКонфигурации = ПараметрыКлиента.ПодробнаяИнформация;
		
		Если ПустаяСтрока(СокрЛП(ПредставлениеЗаголовка)) Тогда
			Если ПараметрыКлиента.Свойство("ПредставлениеОбластиДанных") Тогда
				ЗаголовокПриложения = ПараметрыКлиента.ПредставлениеОбластиДанных;
			Иначе
				ЗаголовокПриложения = ПредставлениеКонфигурации;
			КонецЕсли;
		Иначе
			ЗаголовокПриложения = СокрЛП(ПредставлениеЗаголовка);
		КонецЕсли;
		
	Иначе
		ШаблонЗаголовка = "%1 / %2";
		ЗаголовокПриложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, НСтр("ru = 'Не установлены разделители'"), ПараметрыКлиента.ПодробнаяИнформация);
	КонецЕсли;
	
	Если ПараметрыКлиента.Свойство("РаботаСВнешнимиРесурсамиЗаблокирована")
		И ПараметрыКлиента.Свойство("РазделениеВключено")
		И Не ПараметрыКлиента.РазделениеВключено Тогда
		ЗаголовокПриложения = НСтр("ru = '[КОПИЯ]'") + " " + ЗаголовокПриложения;
	КонецЕсли;
	
	Если ПараметрыКлиента.Свойство("ИдентификаторОтладкиТарифа")
		И ЗначениеЗаполнено(ПараметрыКлиента.ИдентификаторОтладкиТарифа) Тогда 
		ЗаголовокПриложения = СтрШаблон(НСтр("ru = '[%1] %2'"), 
			ПараметрыКлиента.ИдентификаторОтладкиТарифа, ЗаголовокПриложения);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из глобального обработчика ожидания каждые 60 сек
// для возможности централизованно передать данные с клиента на сервер.
// Например, для передачи статистики о количестве открытых окон.
// Не рекомендуется делать собственные глобальные обработчики ожидания,
// чтобы минимизировать общее количество серверных вызовов.
//
// Не рекомендуется передавать данные каждые 60 сек, а делать это реже
// в зависимости от реальной необходимости (ориентироваться на один раз в 20 минут).
// Не рекомендуется передавать избыточно большой объем данных,
// так как это уменьшает отзывчивость клиентского приложения.
//
// Для отправки данных с клиента на сервер заполните параметр Параметры,
// который затем будет передан в процедуру
// ОбщегоНазначенияПереопределяемый.ПриПериодическомПолученииДанныхКлиентаНаСервере.
//
// Параметры:
//  Параметры - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, передаваемого на сервер.
//    * Значение - Произвольный - значение параметра, передаваемого на сервер.
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
//			МодульЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещенияКлиент.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещенияКлиент.ДобавитьПоказатель(МоментНачала,
//		"ЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
//
Процедура ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры) Экспорт
	
КонецПроцедуры

// Вызывается из глобального обработчика ожидания каждые 60 сек после возврата с сервера.
// Требуется, когда сервер возвращает результат для обработки на клиенте.
// Например, признак дальнейшей передачи статистики с клиента на сервер.
//
// Для получения результатов сервера на клиенте они должны быть заполнены
// в параметре Результаты в процедуре
// ОбщегоНазначенияПереопределяемый.ПриПериодическомПолученииДанныхКлиентаНаСервере.
//
// Параметры:
//  Результаты - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, возвращенного с сервера.
//    * Значение - Произвольный - значение параметра, возвращенного с сервера.
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
//			МодульЦентрМониторингаКлиентСлужебный.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещенияКлиент.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещенияКлиент.ДобавитьПоказатель(МоментНачала,
//		"ЦентрМониторингаКлиентСлужебный.ПослеПериодическогоПолученияДанныхКлиентаНаСервере");
//
Процедура ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты) Экспорт
	
КонецПроцедуры

#КонецОбласти
