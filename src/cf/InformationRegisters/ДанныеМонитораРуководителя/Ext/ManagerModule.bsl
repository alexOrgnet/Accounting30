﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Пересчитывает остатки и обороты, отслеживаемые монитором руководителя, по указанной организации
// на указанную дату. Если задан интервал обновления, то проверяет актуальность данных.
// Если данные обновлялись в пределах интервала, то обновление не происходит.
//
// Параметры
// Организация - СправочникСсылка.Организации
// Дата - Дата - Дата, на которую нужно пересчитать данные
// ИнтервалОбновления - Число - Интервал в секундах, в пределах которого не нужно обновлять данные
//
Процедура ОбновитьДанныеМонитора(Организация, Дата, ИнтервалОбновления, РазделыМонитора = Неопределено, ПолучатьПрошлыйПериод = Ложь, СрокХраненияТоваров = 6) Экспорт
		
	Если РазделыМонитора = Неопределено Тогда
		РазделыМонитора = Перечисления.РазделыМонитораРуководителя.РазделыМонитораРуководителяПоУмолчанию();
	КонецЕсли;
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИнтервалОбновления) Тогда
		Если ТекущиеДанныеАктуальны(Организация, Дата, ИнтервалОбновления, РазделыМонитора) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДатаПолученияДанных = КонецДня(Дата);
	
	ДанныеКОбновлению = ПустаяТаблицаОбновляемыхДанных();
	
	ТаблицаДанныхПродажи = Неопределено;
	СтруктураДанныхДДС = Неопределено;
	СтруктураДанныхДоходыРасходИПрибыль = Неопределено;
	
	Для Каждого Раздел Из РазделыМонитора Цикл
		
		ТаблицаДанных = Неопределено;
		
		Если Раздел = Перечисления.РазделыМонитораРуководителя.ОстаткиДенежныхСредств Тогда
			ТаблицаДанных = Отчеты.ОстаткиДенежныхСредств.ПолучитьОстаткиДенежныхСредствДляМонитораРуководителя(Организация, 
				ДатаПолученияДанных);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПоступлениеДенежныхСредств Тогда
			
			Если СтруктураДанныхДДС = Неопределено Тогда
				СтруктураДанныхДДС = Отчеты.АнализДвиженийДенежныхСредств.ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(
					Организация, ДатаПолученияДанных);
			КонецЕсли;
			
			ТаблицаДанных = СтруктураДанныхДДС.ТаблицаПоступлениеДенежныхСредств;
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.РасходДенежныхСредств Тогда
			
			Если СтруктураДанныхДДС = Неопределено Тогда
				СтруктураДанныхДДС = Отчеты.АнализДвиженийДенежныхСредств.ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(
					Организация, ДатаПолученияДанных);
			КонецЕсли;
			
  			ТаблицаДанных = СтруктураДанныхДДС.ТаблицаРасходДенежныхСредств;
			  
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПродажиПоКонтрагентам 
			  Или Раздел = Перечисления.РазделыМонитораРуководителя.ПродажиПоНоменклатурнымГруппам Тогда
			  
			Если ТаблицаДанныхПродажи = Неопределено Тогда
				ТаблицаДанныхПродажи = Отчеты.Продажи.ПолучитьПродажиДляМонитораРуководителя(Организация, ДатаПолученияДанных);
			КонецЕсли;
			
			ТаблицаОстатки = Отчеты.ОстаткиТоваров.ОстаткиТовараСоСрокомХраненияДляМонитораРуководителя(
				Организация, ДатаПолученияДанных, СрокХраненияТоваров);
			
			ТаблицаДанных = ТаблицаДанныхПродажи;
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаОстатки, ТаблицаДанных);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ЗадолженностьПокупателей Тогда
			ТаблицаДанных = Отчеты.ЗадолженностьПокупателей.ПолучитьЗадолженностьПокупателейДляМонитораРуководителя(
				Организация, ДатаПолученияДанных);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ЗадолженностьПоставщикам Тогда
			ТаблицаДанных = Отчеты.ЗадолженностьПоставщикам.ПолучитьЗадолженностьПоставщикамДляМонитораРуководителя(
				Организация, ДатаПолученияДанных);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПросроченнаяЗадолженностьПокупателей Тогда
			ТаблицаДанных = Отчеты.ЗадолженностьПокупателейПоСрокамДолга.ПросроченнаяЗадолженностьДляМонитораРуководителя(
				Организация, ДатаПолученияДанных, Истина);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПросроченнаяЗадолженностьПоставщикам Тогда
			ТаблицаДанных = Отчеты.ЗадолженностьПоставщикамПоСрокамДолга.ПросроченнаяЗадолженностьДляМонитораРуководителя(
				Организация, ДатаПолученияДанных, Истина);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.НеоплаченныеСчетаПокупателям Тогда
			ТаблицаДанных = Отчеты.АнализНеоплаченныхСчетовПокупателям.ДанныеОНеоплаченныхСчетахПокупателей(Организация);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.НеоплаченныеСчетаПоставщиков Тогда
			ТаблицаДанных = Отчеты.АнализНеоплаченныхСчетовПоставщиков.ДанныеОНеоплаченныхСчетахПоставщиков(Организация);
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Доходы Тогда
			
			Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
				СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
					Организация, ДатаПолученияДанных);
			КонецЕсли;
			
			ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаДоходы;
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Расходы Тогда
			
			Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
				СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
					Организация, ДатаПолученияДанных);
			КонецЕсли;
			
  			ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаРасходы;
			
		ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Прибыль Тогда
			
			Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
				СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
					Организация, ДатаПолученияДанных);
			КонецЕсли;
			
  			ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаПрибыльУбыток;

		КонецЕсли;
		
		Если ТаблицаДанных <> Неопределено Тогда
			
			НовыеДанные = ДанныеКОбновлению.Добавить();
			НовыеДанные.Раздел = Раздел;
			НовыеДанные.ТаблицаДанных = ТаблицаДанных;
			
		КонецЕсли;
		
	КонецЦикла;
		
	ДанныеКОбновлениюПрошлыйПериод = ПустаяТаблицаОбновляемыхДанных();
	
	Если ПолучатьПрошлыйПериод И Не ДанныеПрошлогоПериодаАктуальны(Организация, Дата, РазделыМонитора) Тогда
		
		ДатаПолученияДанных = КонецДня(ДобавитьМесяц(ДатаПолученияДанных, -12));
		
		ТаблицаДанныхПродажи = Неопределено;
		СтруктураДанныхДДС = Неопределено;
		СтруктураДанныхДоходыРасходИПрибыль = Неопределено;
		
		Для Каждого Раздел Из РазделыМонитора Цикл
			
			ТаблицаДанных = Неопределено;
			
			Если Раздел = Перечисления.РазделыМонитораРуководителя.ОстаткиДенежныхСредств Тогда
				ТаблицаДанных = Отчеты.ОстаткиДенежныхСредств.ПолучитьОстаткиДенежныхСредствДляМонитораРуководителяСводно(
					Организация, ДатаПолученияДанных);
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПоступлениеДенежныхСредств Тогда
				
				Если СтруктураДанныхДДС = Неопределено Тогда
					СтруктураДанныхДДС = Отчеты.АнализДвиженийДенежныхСредств.ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(
						Организация, ДатаПолученияДанных);
				КонецЕсли;
				
				ТаблицаДанных = СтруктураДанныхДДС.ТаблицаПоступлениеДенежныхСредств;
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.РасходДенежныхСредств Тогда
				
				Если СтруктураДанныхДДС = Неопределено Тогда
					СтруктураДанныхДДС = Отчеты.АнализДвиженийДенежныхСредств.ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(
						Организация, ДатаПолученияДанных);
				КонецЕсли;
				
	  			ТаблицаДанных = СтруктураДанныхДДС.ТаблицаРасходДенежныхСредств;
				  
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПродажиПоКонтрагентам 
				  Или Раздел = Перечисления.РазделыМонитораРуководителя.ПродажиПоНоменклатурнымГруппам Тогда
				  
				Если ТаблицаДанныхПродажи = Неопределено Тогда
					ТаблицаДанныхПродажи = Отчеты.Продажи.ПолучитьПродажиДляМонитораРуководителя(Организация, ДатаПолученияДанных);
				КонецЕсли;
				
				ТаблицаДанных = ТаблицаДанныхПродажи;
			
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ЗадолженностьПокупателей Тогда
				ТаблицаДанных = Отчеты.ЗадолженностьПокупателей.ПолучитьЗадолженностьПокупателейДляМонитораРуководителяСводно(
					Организация, ДатаПолученияДанных);
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ЗадолженностьПоставщикам Тогда
				ТаблицаДанных = Отчеты.ЗадолженностьПоставщикам.ПолучитьЗадолженностьПоставщикамДляМонитораРуководителяСводно(
					Организация, ДатаПолученияДанных);
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПросроченнаяЗадолженностьПокупателей Тогда
				ТаблицаДанных = Отчеты.ЗадолженностьПокупателейПоСрокамДолга.ПросроченнаяЗадолженностьДляМонитораРуководителя(
					Организация, ДатаПолученияДанных, Ложь);
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.ПросроченнаяЗадолженностьПоставщикам Тогда
				ТаблицаДанных = Отчеты.ЗадолженностьПоставщикамПоСрокамДолга.ПросроченнаяЗадолженностьДляМонитораРуководителя(
					Организация, ДатаПолученияДанных, Ложь);
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Доходы Тогда
				
				Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
					СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
						Организация, ДатаПолученияДанных);
				КонецЕсли;
				
				ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаДоходы;
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Расходы Тогда
				
				Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
					СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
						Организация, ДатаПолученияДанных);
				КонецЕсли;
				
				ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаРасходы;
				
			ИначеЕсли Раздел = Перечисления.РазделыМонитораРуководителя.Прибыль Тогда
				
				Если СтруктураДанныхДоходыРасходИПрибыль = Неопределено Тогда
					СтруктураДанныхДоходыРасходИПрибыль = Отчеты.ДоходыРасходы.ДоходыРасходыИПрибыльДляМонитораРуководителя(
						Организация, ДатаПолученияДанных);
				КонецЕсли;
				
				ТаблицаДанных = СтруктураДанныхДоходыРасходИПрибыль.ТаблицаПрибыльУбыток;
			КонецЕсли;
			
			Если ТаблицаДанных <> Неопределено Тогда
				
				НовыеДанные = ДанныеКОбновлениюПрошлыйПериод.Добавить();
				НовыеДанные.Раздел = Раздел;
				НовыеДанные.ТаблицаДанных = ТаблицаДанных;
				
			КонецЕсли;
			
		КонецЦикла;
				
	КонецЕсли;
	
	// Когда все данные посчитаны наложим блокировку и будем записывать
	НачатьТранзакцию();
	Попытка
		
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеМонитораРуководителя");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	Блокировка.Заблокировать();
	
	Для Каждого ДанныеРаздела Из ДанныеКОбновлению Цикл
		ЗаписатьДанныеРаздела(ДанныеРаздела.Раздел,
			Организация,
			Дата,
			ДанныеРаздела.ТаблицаДанных);
	КонецЦикла;
	
	Для Каждого ДанныеРаздела Из ДанныеКОбновлениюПрошлыйПериод Цикл
		ЗаписатьДанныеРаздела(ДанныеРаздела.Раздел,
			Организация,
			КонецДня(Дата),
			ДанныеРаздела.ТаблицаДанных,
			Истина);
	КонецЦикла;
		
	ЗафиксироватьТранзакцию();
		
	Исключение
	
	ОтменитьТранзакцию();
	
	КонецПопытки;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//Параметры:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати,
//   КоллекцияПечатныхФорм - ТаблицаЗначений - Сформированные табличные документы
// 	 ОбъектыПечати - Массив -  массив объектов печать
//   ПараметрыВывода - Структура - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Таблица = ПолучитьИзВременногоХранилища(ПараметрыПечати.ПечатнаяФормаМонитораПуть);
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МониторОсновныхПоказателей", "Монитор основных показателей", Таблица);
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

// Возвращает дату обновления данных монитора руководителя.
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, для данных которой нужно получить дату обновления.
//  РазделыМонитора - Массив - Массив разделов, для которых нужно получить дату обновления.
//
// Возвращаемое значение:
//  ДатаОбновления - Возвращает дату, на которую выполнялось заполнение монитора.
//                   Если нет никаких данных нет - возвращает пустую дату.
Функция ДатаОбновленияМонитора(Организация, РазделыМонитора) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация",     Организация);
	Запрос.УстановитьПараметр("РазделыМонитора", РазделыМонитора);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МИНИМУМ(ДанныеМонитораРуководителя.ДатаОбновления), ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОбновления
	|ИЗ
	|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
	|ГДЕ
	|	ДанныеМонитораРуководителя.Организация = &Организация
	|	И ДанныеМонитораРуководителя.ПрошлыйПериод = ЛОЖЬ
	|	И ДанныеМонитораРуководителя.РазделМонитора В(&РазделыМонитора)";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка.Следующий();
	Возврат Выборка.ДатаОбновления;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	// В роли в тексте ограничения доступа добавлено дополнительное ограничение
	// по "Разделу монитора". При получении расчетных прав для данного регистра нужно это учитывать:
	//  * реально для пользователя данные ограничиваются по разделам монитора.
	//    См. параметр сеанса РазрешенныеРазделыМонитораРуководителя, Перечисления.РазделыМонитораРуководителя.РазрешенныеПользователюРазделы().
	//  * расчетные права РЛС об этом дополнительном ограничении не знают, и если получать ограничение из кода,
	//    то пользователю будут доступны все разделы.
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет актуальность данных, 
// если данные регистра обновлялись в пределах интервала обновления то данные считаются актуальными
// Параметры:
//	Организация - СправочникСсылка.Организации - организация для данных которой нужно проверить актуальность
//	Дата - Дата - дата и время на которую нужно проверить актупльность
//	ИнтервалОбновления - Число - Период времени в секундах в течении которого данные считать актульными
// Возвращаемое значение:
//  Булево - Истина, - Данные регистра актуальны, ложь - нет
//
Функция ТекущиеДанныеАктуальны(Организация, Дата, ИнтервалОбновления, РазделыМонитора)
	
	// По умолчанию считаем данные неактуальными
	ДанныеАктуальны = Ложь;
	
	ДатаОбновления = ДатаОбновленияМонитора(Организация, РазделыМонитора);
	Если ЗначениеЗаполнено(ДатаОбновления) Тогда
		// Если дата обновления регистра входит в интервал, то данные считаются актуальными
		ДанныеАктуальны = ((Дата - ИнтервалОбновления) < ДатаОбновления) И (ДатаОбновления < (Дата + ИнтервалОбновления));
	КонецЕсли;
	
	Возврат ДанныеАктуальны;
	
КонецФункции

// Функция проверяет актуальность данных, 
// если данные регистра обновлялись в пределах интервала обновления то данные считаются актуальными
// Параметры:
//	Организация - СправочникСсылка.Организации - организация для данных которой нужно проверить актуальность
//	Дата - Дата - дата и время на которую нужно проверить актупльность
//	ИнтервалОбновления - Число - Период времени в секундах в течении которого данные считать актульными
// Возвращаемое значение:
//  Булево - Истина, - Данные регистра актуальны, ложь - нет
//
Функция ДанныеПрошлогоПериодаАктуальны(Организация, Дата, РазделыМонитора)
	
	// По умолчанию считаем данные неактуальными
	ДанныеАктуальны = Ложь;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("РазделыМонитора", РазделыМонитора);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Минимум(ДанныеМонитораРуководителя.ДатаОбновления) КАК ДатаОбновления
	|ИЗ
	|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
	|ГДЕ
	|	ДанныеМонитораРуководителя.Организация = &Организация
	|	И ДанныеМонитораРуководителя.ПрошлыйПериод = Истина
	|	И ДанныеМонитораРуководителя.РазделМонитора В(&РазделыМонитора)";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ТипЗнч(Выборка.ДатаОбновления) = Тип("Дата") Тогда
			ДанныеАктуальны = Выборка.ДатаОбновления > Дата;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеАктуальны;
	
КонецФункции

Процедура ЗаписатьДанныеРаздела(РазделМонитора, Организация, Дата, ТаблицаДанных, ПрошлыйПериод = Ложь) 
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ПрошлыйПериод.Установить(ПрошлыйПериод);
	НаборЗаписей.Отбор.РазделМонитора.Установить(РазделМонитора);
		
	НомерСтрокиРаздела = 1;
	Для Каждого Данные Из ТаблицаДанных Цикл
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Данные);
		Запись.Организация        = Организация;
		Запись.ПрошлыйПериод      = ПрошлыйПериод;
		Запись.РазделМонитора     = РазделМонитора;
		Запись.НомерСтрокиРаздела = НомерСтрокиРаздела;
		Запись.ДатаОбновления     = Дата;
		
		НомерСтрокиРаздела = НомерСтрокиРаздела + 1;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПустаяТаблицаОбновляемыхДанных()
	
	ДанныеКОбновлению = Новый ТаблицаЗначений;
	ДанныеКОбновлению.Колонки.Добавить("Раздел");
	ДанныеКОбновлению.Колонки.Добавить("ТаблицаДанных");
	Возврат ДанныеКОбновлению;
	
КонецФункции

#КонецОбласти

#КонецЕсли