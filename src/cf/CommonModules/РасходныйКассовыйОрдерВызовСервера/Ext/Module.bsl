﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ВидыДоговоровДокумента(ВидОперации) Экспорт
	
	Возврат РаботаСДоговорамиКонтрагентовБПВызовСервера.ВидыДоговоровДокумента(
		ВидОперации, Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
	
КонецФункции

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

Функция ДанныеВыбораНалогаПоКБК(Знач КодБК) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.ДанныеВыбораНалогаПоКБК(КодБК);
	
КонецФункции

Функция СуммаВыплаченнойЗарплатыПоВедомости(Знач ПлатежнаяВедомость, Знач Ссылка, Знач НомерСтроки, Знач УчетЗарплатыИКадровВоВнешнейПрограмме, Знач ЭтоОднострочнаФорма = Ложь) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.СуммаВыплаченнойЗарплатыПоВедомости(ПлатежнаяВедомость, Ссылка,
		НомерСтроки, УчетЗарплатыИКадровВоВнешнейПрограмме, ЭтоОднострочнаФорма);
	
КонецФункции

Функция СуммаВыплаченнойЗарплатыРаботнику(Знач Ссылка, Знач ФизЛицо, Знач ПлатежнаяВедомость, Знач УчетЗарплатыИКадровВоВнешнейПрограмме) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.СуммаВыплаченнойЗарплатыРаботнику(Ссылка, ФизЛицо, ПлатежнаяВедомость, УчетЗарплатыИКадровВоВнешнейПрограмме);
	
КонецФункции

Функция СуммаНеВыплаченнойЗарплатыРаботнику(Знач Ссылка, Знач Организация, Знач Дата, Знач ФизЛицо, Знач ПлатежнаяВедомость, Знач УчетЗарплатыИКадровВоВнешнейПрограмме) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.СуммаНеВыплаченнойЗарплатыРаботнику(Ссылка, Организация, Дата, ФизЛицо, ПлатежнаяВедомость, УчетЗарплатыИКадровВоВнешнейПрограмме);
	
КонецФункции

Функция ПолучитьРегистрациюВНалоговомОргане(Знач СтруктураДанныхОбъекта) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.ПолучитьРегистрациюВНалоговомОргане(СтруктураДанныхОбъекта);
	
КонецФункции

Процедура ЗаполнитьОтражениеСтрокиВУСННаСервере(СтрокаПлатеж, Знач ПараметрыУСН) Экспорт
	
	РасходныйКассовыйОрдерФормы.ЗаполнитьОтражениеСтрокиВУСННаСервере(СтрокаПлатеж, ПараметрыУСН);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПлатежаВБюджетНаСервере(РеквизитыОбъекта, Знач ИсточникДанных, Знач НастройкаЗаполнения) Экспорт
	
	РасходныйКассовыйОрдерФормы.ЗаполнитьРеквизитыПлатежаВБюджетНаСервере(РеквизитыОбъекта, ИсточникДанных, НастройкаЗаполнения);
	
КонецПроцедуры

Функция ОснованиеПриИзмененииПоказателяПериода(Знач РеквизитыОбъекта) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.ОснованиеПриИзмененииПоказателяПериода(РеквизитыОбъекта);
	
КонецФункции

Функция НовыеПараметрыПриВыбореВыдать(Знач ПараметрыОбъекта) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.НовыеПараметрыПриВыбореВыдать(ПараметрыОбъекта);
	
КонецФункции

Функция ПоместитьРасшифровкуНалоговыйАгентНДСВХранилище(Объект) Экспорт
	
	Возврат РасходныйКассовыйОрдерФормы.ПоместитьРасшифровкуНалоговыйАгентНДСВХранилище(Объект);
	
КонецФункции

#КонецОбласти

