﻿////////////////////////////////////////////////////////////////////////////////
// ЕдиныйНалоговыйСчетИнтеграцияКлиентБП:
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура СоздатьПлатежныйДокумент(Форма) Экспорт
	
	ОсновнаяЗапись = Форма.ТаблицаСальдо[0];
	Задолженность  = Форма.БлижайшийПлатеж + ОсновнаяЗапись.Задолженность;
	
	ТекущийДокумент =
		ЕдиныйНалоговыйСчетИнтеграцияВызовСервераБП.ПараметрыФормыПлатежногоДокумента(
			Форма.Объект.Организация,
			Форма.Объект.Период,
			ОсновнаяЗапись.РекомендуемыйПлатеж);
	
	ОткрытьФорму(
		"Документ.ПлатежноеПоручение.Форма.ФормаДокументаНалоговая",
		ТекущийДокумент,
		Форма,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПодсказкаИнтеграцияСЛичнымКабинетомЕНСОбработкаНавигационнойСсылки(Организация, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "ПодключитьПромоЕНС" Тогда
		ДокументооборотСКОКлиент.ПоказатьРекламуПромоЕНС(Организация);
	ИначеЕсли НавигационнаяСсылка = "СведенияОбУплатеНалогов" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Новый Структура);
		ПараметрыФормы.Отбор.Вставить("Организация", Организация);
		ОткрытьФорму("Документ.СведенияОбУплатеНалогов.ФормаСписка", ПараметрыФормы, , Истина);
	ИначеЕсли НавигационнаяСсылка = "ЛичныйКабинетЕНС" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", Организация);
		ОткрытьФорму("Обработка.ЕдиныйНалоговыйСчетЛичныйКабинет.Форма", ПараметрыФормы, , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


