﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Владелец", ПолучитьФизическоеЛицо(ПараметрКоманды));
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьФизическоеЛицо(Сотрудник)
	Возврат УчетЗарплаты.ПолучитьФизическоеЛицо(Сотрудник);
КонецФункции
