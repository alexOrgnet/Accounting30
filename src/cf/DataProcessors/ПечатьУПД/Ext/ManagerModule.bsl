﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ПЕЧАТНЫХ ФОРМ

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ЕстьСчетаФактурыВыданные   = Ложь;
	ЕстьСчетаФактурыПолученные = Ложь;
	
	Для каждого Объект Из МассивОбъектов Цикл
		Если ТипЗнч(Объект) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			ЕстьСчетаФактурыВыданные = Истина;
			Прервать;
		ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
			ЕстьСчетаФактурыПолученные = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаМакетовУПД = УчетНДС.ТаблицаМакетовУПД();
	
	// Печать УПД в статусе "1"
	Если ЕстьСчетаФактурыВыданные ИЛИ ЕстьСчетаФактурыПолученные Тогда
		Для Каждого МакетУПД ИЗ ТаблицаМакетовУПД Цикл
			Если МакетУПД.Статус <> "1" Тогда
				Продолжить;
			КонецЕсли;
			Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, МакетУПД.ИДМакета) Тогда
				
				Если ЕстьСчетаФактурыВыданные Тогда
					ТекстЗапроса = Документы.СчетФактураВыданный.ТекстЗапросаПечатьСчетовФактур(
						МакетУПД.ВерсияПостановленияНДС1137, Истина, МакетУПД.ПрослеживаемыеТовары);
				Иначе
					ТекстЗапроса = Документы.СчетФактураПолученный.ТекстЗапросаПечатьСчетовФактур(
						МакетУПД.ВерсияПостановленияНДС1137, МакетУПД.ПрослеживаемыеТовары);
				КонецЕсли;
				
				СтруктураПараметровПечати = УчетНДС.НовыйСтруктураПараметровПечатиУПД_УКД();
				СтруктураПараметровПечати.МассивОбъектов              = МассивОбъектов;
				СтруктураПараметровПечати.ОбъектыПечати               = ОбъектыПечати;
				СтруктураПараметровПечати.ТекстЗапросаДокументам      = ТекстЗапроса;
				СтруктураПараметровПечати.ТолькоПередаточныйДокумент  = Ложь;
				СтруктураПараметровПечати.ТабДокумент                 = Неопределено;
				СтруктураПараметровПечати.ПараметрыПечати             = ПараметрыПечати;
				СтруктураПараметровПечати.КлючПараметровПечати        = МакетУПД.КлючПараметровПечати;
				СтруктураПараметровПечати.ПолныйПутьКМакету           = МакетУПД.ПолныйПутьКМакету;
				СтруктураПараметровПечати.ПараметрыВывода             = ПараметрыВывода;
				
				ТабличныйДокумент = УчетНДС.ПечатьУниверсальныхПередаточныхДокументов(СтруктураПараметровПечати);
				
				УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
					КоллекцияПечатныхФорм, МакетУПД.ИДМакета, МакетУПД.СинонимМакета,ТабличныйДокумент,,МакетУПД.ПолныйПутьКМакету);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Печать УПД в статусе "2"
	Для Каждого МакетУПД ИЗ ТаблицаМакетовУПД Цикл
		Если МакетУПД.Статус <> "2" Тогда
			Продолжить;
		КонецЕсли;
		Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, МакетУПД.ИДМакета) Тогда
			ТекстЗапросаПечатьУниверсальныхПередаточныхДокументов = "";
			Для каждого Объект Из МассивОбъектов Цикл
				Если ТипЗнч(Объект) <> Тип("ДокументСсылка.СчетФактураВыданный")
					И ТипЗнч(Объект) <> Тип("ДокументСсылка.СчетФактураПолученный") Тогда
					ТекстЗапросаПечатьУниверсальныхПередаточныхДокументов = 
						Документы[Объект.Метаданные().Имя].ТекстЗапросаПечатьУниверсальныхПередаточныхДокументов(
							МакетУПД.ВерсияПостановленияНДС1137, МакетУПД.ПрослеживаемыеТовары);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ПустаяСтрока(ТекстЗапросаПечатьУниверсальныхПередаточныхДокументов) Тогда
				
				СтруктураПараметровПечати = УчетНДС.НовыйСтруктураПараметровПечатиУПД_УКД();
				СтруктураПараметровПечати.МассивОбъектов              = МассивОбъектов;
				СтруктураПараметровПечати.ОбъектыПечати               = ОбъектыПечати;
				СтруктураПараметровПечати.ТекстЗапросаДокументам      = ТекстЗапросаПечатьУниверсальныхПередаточныхДокументов;
				СтруктураПараметровПечати.ТолькоПередаточныйДокумент  = Истина;
				СтруктураПараметровПечати.ТабДокумент                 = Неопределено;
				СтруктураПараметровПечати.ПараметрыПечати             = ПараметрыПечати;
				СтруктураПараметровПечати.КлючПараметровПечати        = МакетУПД.КлючПараметровПечати;
				СтруктураПараметровПечати.ПолныйПутьКМакету           = МакетУПД.ПолныйПутьКМакету;
				СтруктураПараметровПечати.ПараметрыВывода             = ПараметрыВывода;
				
				ТабличныйДокумент = УчетНДС.ПечатьУниверсальныхПередаточныхДокументов(СтруктураПараметровПечати);
					
				УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
					КоллекцияПечатныхФорм, МакетУПД.ИДМакета, МакетУПД.СинонимМакета, ТабличныйДокумент,,МакетУПД.ПолныйПутьКМакету);
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыВывода.Вставить("ИмяФайлаПоВходящимНомерам", Истина);
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

#КонецЕсли