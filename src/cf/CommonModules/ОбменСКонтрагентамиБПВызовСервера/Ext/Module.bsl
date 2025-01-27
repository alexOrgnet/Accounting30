﻿#Область СлужебныйПрограммныйИнтерфейс

// Поиск и создание учетного документа при отражении в учете документа Акт сверки взаиморасчетов (информация отправителя).
// Формат по приказу ЕД-7-26/405@.
//
// Параметры:
//  ДеревоДанных		 - ДеревоЗначений - данные электронного документа в виде заполненного макета 
//                         см. Обработка.ОбменСКонтрагентами.Макет.АктСверкиВзаиморасчетов_ИнформацияОтправителя.
//  ДокументУчета	     - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на документ учета, если он уже
//                         прикреплен к электронному документу.
Процедура ПослеПодбораУчетногоДокументаАктСверкиВзаиморасчетов(ЭлектронныйДокумент, ДокументУчета) Экспорт
	
	ПараметрыЗаполнения = ЭлектронныеДокументыЭДО.ДанныеДокументовДляОтраженияВУчете(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭлектронныйДокумент))[0];
	
	ПараметрыПолучения = ЭлектронныеДокументыЭДО.НовыеПараметрыПолученияДанныхДокумента();
	ПараметрыПолучения.ОсновнойФайл = ПараметрыЗаполнения.ДанныеОсновногоФайла;
	ПараметрыПолучения.ДополнительныйФайл = ПараметрыЗаполнения.ДанныеДополнительногоФайла;
	
	Результат = ЭлектронныеДокументыЭДО.ДанныеДокументаДляЗагрузкиПросмотра(ПараметрыПолучения);
	
	НовыйЭД = Результат.НовыйЭД;
	ДеревоЭД = НовыйЭД.ЗначениеРеквизита;
	
	Если ЗначениеЗаполнено(ДеревоЭД) Тогда
		ОбменСКонтрагентамиБП.НайтиСоздатьАктСверкиВзаиморасчетов(ДеревоЭД, ДокументУчета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти