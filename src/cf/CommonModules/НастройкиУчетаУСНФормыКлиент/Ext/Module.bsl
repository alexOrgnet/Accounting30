﻿
////////////////////////////////////////////////////////////////////////////////
// Универсальные методы для формы записи регистра и формы настройки налогов
//
// Клиентские методы формы записи регистра сведений НастройкиУчетаУСН
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийЭлементовФормы

Процедура ОрганизацияПриИзменении(Форма) Экспорт
	
	Запись = Форма.НастройкиУчетаУСН;
	
	ЗаполнитьЗначенияСвойств(Форма,
		НастройкиУчетаУСНФормыВызовСервера.НастройкиОрганизацииИСистемыНалогообложения(
		Форма.НастройкиУчетаУСН.Организация, Форма.НастройкиУчетаУСН.Период));
	
	Если Форма.ПрименяетсяУСНДоходы Тогда
		Запись.СтавкаНалога = 6;
	ИначеЕсли Форма.ПрименяетсяУСНДоходыМинусРасходы Тогда
		Запись.СтавкаНалога = 15;
	КонецЕсли;
	
	НастройкиУчетаУСНФормыКлиентСервер.УправлениеФормой(Форма);
	
КонецПроцедуры

Процедура ПериодНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	НачалоПериода = Форма.НастройкиУчетаУСН.Период;
	КонецПериода  = КонецГода(НачалоПериода);
	
	ПараметрыВыбора = Новый Структура;
	
	ПараметрыВыбора.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыВыбора.Вставить("КонецПериода",  КонецПериода);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, Форма);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал",
		ПараметрыВыбора, Форма.Элементы.ПрименяетсяС, , , , ОписаниеОповещения);
	
КонецПроцедуры

Процедура ПериодПриИзменении(Форма) Экспорт
	
	Форма.ПрименяетсяС = Формат(Форма.НастройкиУчетаУСН.Период, "ДФ='ММММ гггг'");
	
	НастройкиУчетаУСНФормыКлиентСервер.УправлениеФормой(Форма);
	
КонецПроцедуры

Процедура НалоговыеКаникулыПриИзменении(Форма) Экспорт
	
	УстановитьСтавкуНалога(Форма);
	
	НастройкиУчетаУСНФормыКлиентСервер.УправлениеФормой(Форма);
	
КонецПроцедуры

Процедура ПорядокОтраженияАвансаПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если ТипЗнч(Форма.ПорядокОтраженияАванса) = Тип("СправочникСсылка.Патенты") Тогда
		
		НастройкиУчетаУСН.ПорядокОтраженияАванса = ПредопределенноеЗначение("Перечисление.ПорядокОтраженияАвансов.ДоходПатент");
		НастройкиУчетаУСН.Патент = Форма.ПорядокОтраженияАванса;
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокОтраженияАванса = Форма.ПорядокОтраженияАванса;
		НастройкиУчетаУСН.Патент = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПорядокОтраженияАвансаУСНОчистка(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОснованиеЛьготыПриИзменении(Форма) Экспорт
	
	Запись = Форма.НастройкиУчетаУСН;
	
	Запись.ОснованиеЛьготнойСтавки = УчетУСНКлиентСервер.ПолныйКодОснованияЛьготы(
		Форма.ОснованиеЛьготыУСННомерСтатьи,
		Форма.ОснованиеЛьготыУСНПункт,
		Форма.ОснованиеЛьготыУСНПодпункт);
	
КонецПроцедуры

Процедура ДекорацияОснованиеЛьготыУСНОбработкаНавигационнойСсылки(Форма, Элемент, ТекстСсылки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПериодЧтенияНастройки = НастройкиУчетаУСНФормыКлиентСервер.ПериодЧтенияНастройки(Форма);
	АдресСтатьиИТС = УчетУСНКлиентСервер.СсылкаНаРазделИТСРегиональныеСтавкиУСН(Форма.КодРегиона, ПериодЧтенияНастройки);
	
	ПерейтиПоНавигационнойСсылке(АдресСтатьиИТС);
	
КонецПроцедуры

Процедура ДекорацияОснованиеЛьготыПримерЗаполненияНажатие(Форма, Элемент) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Период", НастройкиУчетаУСНФормыКлиентСервер.ПериодЧтенияНастройки(Форма));
	ПараметрыФормы.Вставить("КодРегиона", Форма.КодРегиона);
	
	ОткрытьФорму("РегистрСведений.НастройкиУчетаУСН.Форма.ПримерЗаполненияОснованияЛьготы", ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ПередачаВПроизводствоПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если НЕ Форма.УменьшатьНаНЗП Тогда
		
		Если Форма.ПередачаВПроизводство Тогда
			
			НастройкиУчетаУСН.ПорядокПризнанияМатериальныхРасходов =
				ПредопределенноеЗначение("Перечисление.ПорядокПризнанияМатериальныхРасходов.ПоФактуСписания");
			
		Иначе
			
			НастройкиУчетаУСН.ПорядокПризнанияМатериальныхРасходов =
				ПредопределенноеЗначение("Перечисление.ПорядокПризнанияМатериальныхРасходов.ПоОплатеПоставщику");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УменьшатьНаНЗППриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Форма.УменьшатьНаНЗП Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияМатериальныхРасходов =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияМатериальныхРасходов.УменьшатьРасходыНаОстатокНЗП");
		
	ИначеЕсли Форма.ПередачаВПроизводство Тогда 
		
		НастройкиУчетаУСН.ПорядокПризнанияМатериальныхРасходов =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияМатериальныхРасходов.ПоФактуСписания");
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокПризнанияМатериальныхРасходов =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияМатериальныхРасходов.ПоОплатеПоставщику");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура РеализацияПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Не Форма.ПолучениеДохода Тогда
		
		Если Форма.Реализация Тогда 
			
			НастройкиУчетаУСН.ПорядокПризнанияРасходовПоТоварам =
				ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоТоварам.ПоФактуРеализации");
			
		Иначе
			
			НастройкиУчетаУСН.ПорядокПризнанияРасходовПоТоварам =
				ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоТоварам.ПоОплатеПоставщику");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучениеДоходаПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Форма.ПолучениеДохода Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияРасходовПоТоварам =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоТоварам.ПоФактуПолученияДохода");
		
	ИначеЕсли Форма.Реализация Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияРасходовПоТоварам =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоТоварам.ПоФактуРеализации");
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокПризнанияРасходовПоТоварам =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоТоварам.ПоОплатеПоставщику");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПризнаниеРасходаПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Форма.ПризнаниеРасхода Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияРасходовПоНДС =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоНДС.ВключатьВСтоимость");
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокПризнанияРасходовПоНДС =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияРасходовПоНДС.ПоОплатеПоставщику");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДопРасходыПризнаниеРасходаПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Форма.ДопРасходыПризнаниеРасхода Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияДопРасходов =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияДопРасходов.ВключатьВСтоимость");
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокПризнанияДопРасходов =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияДопРасходов.ПоОплатеПоставщику");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаможенныеПлатежиПризнаниеРасходаПриИзменении(Форма) Экспорт
	
	НастройкиУчетаУСН = Форма.НастройкиУчетаУСН;
	
	Если Форма.ТаможенныеПлатежиПризнаниеРасхода Тогда
		
		НастройкиУчетаУСН.ПорядокПризнанияТаможенныхПлатежей =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияТаможенныхПлатежей.ВключатьВСтоимость");
		
	Иначе
		
		НастройкиУчетаУСН.ПорядокПризнанияТаможенныхПлатежей =
			ПредопределенноеЗначение("Перечисление.ПорядокПризнанияТаможенныхПлатежей.ПоОплате");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ВыбратьПериодЗавершение(РезультатВыбора, Форма) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись = Форма.НастройкиУчетаУСН;
	
	Форма.НастройкиУчетаУСН.Период = РезультатВыбора.НачалоПериода;
	Форма.ДатаИзменения = РезультатВыбора.НачалоПериода;
	
	ЗаполнитьЗначенияСвойств(Форма,
		НастройкиУчетаУСНФормыВызовСервера.НастройкиОрганизацииИСистемыНалогообложения(
		Форма.НастройкиУчетаУСН.Организация, Форма.НастройкиУчетаУСН.Период));
	
	Если Форма.ПрименяетсяУСНДоходы Тогда
		Запись.СтавкаНалога = 6;
	ИначеЕсли Форма.ПрименяетсяУСНДоходыМинусРасходы Тогда
		Запись.СтавкаНалога = 15;
	КонецЕсли;
	
	НастройкиУчетаУСНФормыКлиентСервер.УправлениеФормой(Форма);
	
КонецПроцедуры

Процедура УстановитьСтавкуНалога(Форма)
	
	Запись = Форма.НастройкиУчетаУСН;
	
	Если Не Запись.НалоговыеКаникулы Тогда
		Если Форма.ПрименяетсяУСНДоходы Тогда
			Запись.СтавкаНалога = 6;
		ИначеЕсли Форма.ПрименяетсяУСНДоходыМинусРасходы Тогда
			Запись.СтавкаНалога = 15;
		КонецЕсли;
	Иначе
		Запись.СтавкаНалога = 0;
	КонецЕсли;
	
	Форма.ТекущаяСтавкаНалога = Запись.СтавкаНалога;
	
КонецПроцедуры

#КонецОбласти
