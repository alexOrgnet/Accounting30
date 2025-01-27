﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Отбор = Новый Структура;
	Налог = ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество");
	Отбор.Вставить("Налог", Налог);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Налог", Налог); // для поиска формы по ключу
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Сверка расчета налога на имущество с ФНС'"));
	
	ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		Ложь, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры 