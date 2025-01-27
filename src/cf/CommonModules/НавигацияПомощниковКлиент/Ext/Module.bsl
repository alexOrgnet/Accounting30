﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоНавигационнаяСсылкаШага(НавигационнаяСсылка) Экспорт
	
	ЭтоСсылкаШага = Ложь;
	Для НомерТекущегоШага = 1 По НавигацияПомощниковКлиентСервер.МаксимальноеЧислоШагов() Цикл
		Если НавигационнаяСсылка = НавигацияПомощниковКлиентСервер.ИмяШага(НомерТекущегоШага) Тогда
			ЭтоСсылкаШага = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭтоСсылкаШага;
	
КонецФункции

Процедура ОбработатьНавигационнуюСсылку(НавигационнаяСсылка, СтруктураНавигации) Экспорт
	
	СтруктураШага = СтруктураНавигации[НавигационнаяСсылка];
	Если СтруктураШага <> Неопределено Тогда
		ОткрытьФормуШага(СтруктураШага);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьЭтап(НомерТекущегоШага, СтруктураНавигации, ПараметрыПомощника = Неопределено) Экспорт
	
	СтруктураШага = СтруктураНавигации[НавигацияПомощниковКлиентСервер.ИмяШага(НомерТекущегоШага)];
	Если СтруктураШага <> Неопределено Тогда
		ОткрытьФормуШага(СтруктураШага, ПараметрыПомощника);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФормуШага(СтруктураШага, ПараметрыПомощника = Неопределено)
	
	ИмяФормы = СтруктураШага.ИмяФормы;
	СтруктураПараметровФормы = СтруктураШага.СтруктураПараметровФормы;
	Если ПараметрыПомощника <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметровФормы, ПараметрыПомощника, Истина);
	КонецЕсли;
	
	Форма = ПолучитьФорму(
		ИмяФормы,
		СтруктураПараметровФормы,
		,
		Ложь);
		
	Если Форма <> Неопределено Тогда
		Если Форма.Открыта() Тогда
			// Если форма уже открыта, то передадим ей новый параметр навигации.
			Оповестить("ИзменитьПараметрНавигации", СтруктураПараметровФормы.НавигацияПараметрФормы);
			Форма.Активизировать();
		Иначе
			Форма.Открыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти