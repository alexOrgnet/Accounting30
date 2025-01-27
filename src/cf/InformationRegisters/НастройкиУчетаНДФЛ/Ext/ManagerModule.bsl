﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура устанавливает значения регистра по умолчанию
//
// Параметры:
//   Запись           - РегистрСведенийЗапись - запись регистра
//   ДанныеЗаполнения - Структура - где ключ - имя ресурса
//
Процедура УстановкаНастроекПоУмолчанию(Запись, ДанныеЗаполнения) Экспорт
	
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Период",
		НачалоГода(ТекущаяДатаСеанса()));
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Организация",
		БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
		
	ЭтоФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Организация, "ЮридическоеФизическоеЛицо")
		= Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
	Если НЕ ЭтоФизЛицо Тогда
			Запись.Организация = Справочники.Организации.ПустаяСсылка();
		Возврат;
	КонецЕсли;
		
	
	Если ЗначениеЗаполнено(Запись.Организация) Тогда
		
		НастройкиУчета.УстановитьЗначениеПоУмолчанию(
			Запись,
			ДанныеЗаполнения,
			"ОсновнойВидДеятельности",
			РегистрыСведений.ВидыДеятельностиПредпринимателей.ВидДеятельностиПоУмолчанию(Запись.Организация));
		
		НастройкиУчета.УстановитьЗначениеПоУмолчанию(
			Запись,
			ДанныеЗаполнения,
			"ВестиУчетПоВидамДеятельности",
			НеобходимоВестиУчетПоВидамДеятельности(Запись.Организация, Запись.Период, Запись.ОсновнойВидДеятельности));
		
	КонецЕсли;
	
	// Учет доходов
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"АвансыВключаютсяВДоходыВПериодеПолучения",
		Истина);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ВидДеятельностиДоходовПоАвансам",
		Запись.ОсновнойВидДеятельности);
	
	// Учет расходов
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ДляПризнанияРасходовТребуетсяПолучениеДохода",
		Ложь);
	
	НастройкиУчета.УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"ПризнаватьРасходыПоОперациямПрошлогоГода",
		Ложь);
	
КонецПроцедуры

// Возвращает признак необходимости вести учет по нескольким видам деятельности
//
// Параметры:
//   Организация             - СправочникСсылка.Организации - организация, для которой необходимо проверить данные.
//   Период                  - Дата - период, на который необходимо проверить данные.
//   ОсновнойВидДеятельности - СправочникСсылка.ВидыДеятельностиПредпринимателей - вид деятельности по умолчанию.
//   Причина                 - Строка - в нее возвращается пользовательское описание причины установки учета по нескольким видам деятельности
// 
// Возвращаемые значения:
//  Булево - признак необходимости вести учет по нескольким видам деятельности
//
Функция НеобходимоВестиУчетПоВидамДеятельности(Организация, Период, ОсновнойВидДеятельности, Причина = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ОсновнойВидДеятельности) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НачалоНалоговогоПериода = НачалоГода(Период);
	КонецНалоговогоПериода  = КонецГода(Период);
	
	ХарактерОсновнойДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнойВидДеятельности, "ХарактерДеятельности");
	
	ПлательщикЕНВД = УчетнаяПолитика.ПлательщикЕНВДЗаПериод(Организация, НачалоНалоговогоПериода, КонецНалоговогоПериода);
	ХарактерыДеятельностиЕНВД = УчетДоходовИРасходовПредпринимателя.ХарактерыДеятельностиЕНВД();
	ОсновнойВидДеятельностиНаЕНВД = (ХарактерыДеятельностиЕНВД.Найти(ХарактерОсновнойДеятельности) <> Неопределено);
	Если ПлательщикЕНВД И Не ОсновнойВидДеятельностиНаЕНВД Тогда
		Причина = НСтр("ru = 'Если предприниматель совмещает ЕНВД с Общей системой налогообложения, небходимо вести раздельный учет доходов и расходов.'");
		Возврат Истина;
	КонецЕсли;
	
	ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатентЗаПериод(Организация, НачалоНалоговогоПериода, КонецНалоговогоПериода);
	ХарактерыДеятельностиУСНПатент = УчетДоходовИРасходовПредпринимателя.ХарактерыДеятельностиУСНПатент();
	ОсновнойВидДеятельностиНаПатенте = (ХарактерыДеятельностиУСНПатент.Найти(ХарактерОсновнойДеятельности) <> Неопределено);
	Если ПрименяетсяУСНПатент И Не ОсновнойВидДеятельностиНаПатенте Тогда
		Причина = НСтр("ru = 'Если  предприниматель совмещает Патентную систему налогообложения с Общей, небходимо вести раздельный учет доходов и расходов.'");
		Возврат Истина;
	КонецЕсли;
	
	Если ПлательщикЕНВД И ПрименяетсяУСНПатент Тогда
		Причина = НСтр("ru = 'Если предприниматель совмещает ЕНВД, Патентную и Общую систему налогообложения, небходимо вести раздельный учет доходов и расходов.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает характер деятельности, соответствующий переданным видам деятельности
//
// Параметры:
//   ОсновнойВидДеятельности           - СправочникСсылка.ВидыДеятельностиПредпринимателей - вид деятельности по умолчанию.
//   ВидДеятельностиДоходовПоАвансамИП - СправочникСсылка.ВидыДеятельностиПредпринимателей - вид деятельности по умолчанию для учета авансов.
// 
// Возвращаемые значения:
//  Структура - содержит значения типа ПеречислениеСсылка.ХарактерДеятельности
//
Функция ПолучитьХарактерыВидовДеятельности(ОсновнойВидДеятельности, ВидДеятельностиДоходовПоАвансамИП) Экспорт
	
	ХарактерыДеятельности	= Новый Структура;
	ХарактерыДеятельности.Вставить("ОсновнойХарактерДеятельности",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнойВидДеятельности, "ХарактерДеятельности"));
	ХарактерыДеятельности.Вставить("ХарактерДеятельностиДоходовПоАвансамИП",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДеятельностиДоходовПоАвансамИП, "ХарактерДеятельности"));
		
	Возврат ХарактерыДеятельности;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ОбособленныеПодразделения 
	|	ПО ОбособленныеПодразделения.ГоловнаяОрганизация = ЭтотСписок.Организация.ГоловнаяОрганизация
	|;
	|РазрешитьЧтение
	|ГДЕ
	| ЗначениеРазрешено(ОбособленныеПодразделения.Ссылка)
	|
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	| ЗначениеРазрешено(ЭтотСписок.Организация)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли