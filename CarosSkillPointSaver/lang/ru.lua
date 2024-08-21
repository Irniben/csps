-- Russian Version

local L = {}

	L.SI_BINDING_NAME_CSPS_SHOW = "Вызвать Skill Point Saver"
	L.SI_BINDING_NAME_CSPS_CPHK1 = "Профиль панелей ОГ №1"
	L.SI_BINDING_NAME_CSPS_CPHK2 = "Профиль панелей ОГ №2"
	L.SI_BINDING_NAME_CSPS_CPHK3 = "Профиль панелей ОГ №3"
	L.SI_BINDING_NAME_CSPS_CPHK4 = "Профиль панелей ОГ №4"
	L.SI_BINDING_NAME_CSPS_CPHK5 = "Профиль панелей ОГ №5"
	L.SI_BINDING_NAME_CSPS_CPHK6 = "Профиль панелей ОГ №6"
	L.SI_BINDING_NAME_CSPS_CPHK7 = "Профиль панелей ОГ №7"
	L.SI_BINDING_NAME_CSPS_CPHK8 = "Профиль панелей ОГ №8"
	L.SI_BINDING_NAME_CSPS_CPHK9 = "Профиль панелей ОГ №9"
	L.SI_BINDING_NAME_CSPS_CPHK10 = "Профиль панелей ОГ №10"
	L.SI_BINDING_NAME_CSPS_CPHK11 = "Профиль панелей ОГ №11"
	L.SI_BINDING_NAME_CSPS_CPHK12 = "Профиль панелей ОГ №12"
	L.SI_BINDING_NAME_CSPS_CPHK13 = "Профиль панелей ОГ №13"
	L.SI_BINDING_NAME_CSPS_CPHK14 = "Профиль панелей ОГ №14"
	L.SI_BINDING_NAME_CSPS_CPHK15 = "Профиль панелей ОГ №15"
	L.SI_BINDING_NAME_CSPS_CPHK16 = "Профиль панелей ОГ №16"
	L.SI_BINDING_NAME_CSPS_CPHK17 = "Профиль панелей ОГ №17"
	L.SI_BINDING_NAME_CSPS_CPHK18 = "Профиль панелей ОГ №18"
	L.SI_BINDING_NAME_CSPS_CPHK19 = "Профиль панелей ОГ №19"
	L.SI_BINDING_NAME_CSPS_CPHK20 = "Профиль панелей ОГ №20"
	
	-- General UI
	L.CSPS_MyWindowTitle = "Caro's Skill Point Saver"
	
	L.CSPS_Tooltiptext_Close = "Закрыть это окно"
	L.CSPS_Tooltiptext_Read = "Считать сведения с персонажа"
	L.CSPS_Tooltiptext_Save = "Сохранить содержимое окна"
	L.CSPS_Tooltiptext_Load = "Загрузить сохранённый профиль"
	L.CSPS_Tooltiptext_Apply = "Применить"
	L.CSPS_Tooltiptext_Help = "Помогите!"
	L.CSPS_Tooltiptext_CP1 = "Применить синюю ветку Очков Героя?"
	L.CSPS_Tooltiptext_CP2 = "Применить красную ветку Очков Героя?"
	L.CSPS_Tooltiptext_CP3 = "Применить зелёную ветку Очков Героя?"
	
	L.CSPS_Tooltiptext_ApplyCP = "Применить Очки Героя"
	L.CSPS_Tooltiptext_ATTR = "Применить очки характеристик"
	L.CSPS_Tooltiptext_Sk = "Применить очки навыков"
	
	L.CSPS_Tooltiptext_MinusSk = "Снять преобразование / убрать способность"
	L.CSPS_Tooltiptext_PlusSk = "Преобразовать / приобрести способность"
	L.CSPS_Tooltiptext_Optional = "Настройки"
	L.CSPS_Tooltiptext_SkIcon = "Перетащите способность, чтобы выставить её на панель..."
	L.CSPS_Tooltiptext_SrcCombo	 = "Выберите формат импорта/экспорта."
	L.CSPS_Tooltiptext_AddProfile = "Добавить профиль..."
	L.CSPS_Tooltiptext_RenameProfile = "Переименовать профиль..."
	L.CSPS_Tooltiptext_DeleteProfile = "Удалить профиль..."
	L.CSPS_Tooltiptext_ProfileCombo = "Выберите профиль для сохрания/загрузки сведений..."
	L.CSPS_Tooltiptext_MinusSkType = "Убрать все способности этого типа."
	L.CSPS_Tooltiptext_MinusSkLine = "Убрать все способности из этой ветки."
	L.CSPS_Tooltiptext_PlusSkLine = "Приобрести все пассивные способности и повысить их до макс. уровня"
	L.CSPS_Tooltiptext_MinusAttr = "Убрать очко характеристики (удерживая %s — 10 очков)"
	L.CSPS_Tooltiptext_PlusAttr = "Вложить очко характеристики (удерживая %s — 10 очков)"
	L.CSPS_Tooltiptext_SaveProfile = "Сохранить этот профиль..."
	L.CSPS_Tooltiptext_CPProfile = "Профили ОГ" -- also used for the profile-section title
	L.CSPS_Tooltiptext_PlusCP = "Вложить Очко Героя (удерживая %s — 10 очков / след. рубеж)"
	L.CSPS_Tooltiptext_MinusCP = "Убрать Очко Героя (удерживая %s — 10 очков / пред. рубеж)"
	L.CSPS_Tooltiptext_CpHbHk = "Нажмите тут, чтобы поменять назначенную клавишу для этого профиля."
	L.CSPS_Tooltip_CPBar = "Перетащите способность из списка сюда, чтобы выставить её на панель. Щелкните правой кнопкой мыши, чтобы её снять."
	L.CSPS_Tooltip_CPPUpdate = "Последняя редакция: <<2>>.<<1>>.<<3>>"
	L.CSPS_Tooltip_CPPWebsite = "За актуальными обновлениями обращайтесь сюда:\n<<1>>"
	L.CSPS_Tooltip_CPCustomBar = "Показывать ли панель с выставленными способностями ОГ в процессе игры"
	L.CSPS_Tooltip_CPCustomIcons = "Использовать ли в аддоне нестандартные значки для активных способностей ОГ"
	
	L.CSPS_Tooltip_ReverseLabel = "Стандартный порядок при импорте текста: Число, Название.\nВключите, чтобы применить обратный порядок: Название, Число."
	L.CSPS_Tooltip_CapLabel = "Если включено, аддон не будет импортировать очков больше чем доступно на данной учётной записи."
	L.CSPS_Tooltip_SelectBarProfile = "|t26:26:esoui/art/miscellaneous/icon_lmb.dds|t: Выбрать подпрофиль (%s)\n|t26:26:esoui/art/miscellaneous/icon_rmb.dds|t: Редактировать подпрофили" 
	L.CSPS_Tooltip_ImpExp_CleanUp = "Убрать все специальные символы из текста. Также эта процедура уберёт все пары чисел через чёрточку, которыми ряд авторов (типа AlcastHQ) обозначает диапазоны очков, что может привести к ошибкам импорта."
	
	L.CSPS_Tooltip_AddBind1 = "Если вы добавите это условие, каждый раз при загрузке выбранного профиля Dressing Room будет автоматически применяться текущая группа."
	L.CSPS_Tooltip_AddBind2 = "Если вы добавите это условие, каждый раз при загрузке выбранного профиля Alpha Gear будет автоматически применяться текущая группа."
	L.CSPS_Tooltip_AddBind3 = "Если вы добавите это условие, каждый раз при посещении выбранной локации будет автоматически применяться текущая группа."
	
	L.CSPS_Tooltip_CPAutoOpen = "Включите, чтобы аддон автоматически показывался при открытии экрана очков героя."
	
	L.CSPS_Tooltiptext_DeleteBinding = "Убрать назначение"
	
	L.CSPS_Tooltip_AddConnection = "Связать с текущим профилем"
	L.CSPS_Tooltip_RemoveConnection = "Разорвать связь с текущим профилем"
	L.CSPS_Tooltip_ShowConnection = "Связано с подпрофилем: %s\n\n Внесённые в этой дисциплине изменения можно применить на персонажа, но нельзя сохранить в текущий профиль сборки. Загрузка профиля автоматически попытается загрузить связанный подпрофиль.\n\n|t26:26:esoui/art/miscellaneous/icon_rmb.dds|t: Разорвать связь"
	
	L.CSPS_Tooltiptext_LoadAndApply = "Загрузить и применить"
	L.CSPS_MORPH = "<<1[Без преобр./Преобр. №$d/Преобр. №$d/Преобр. №$d]>>"
	L.CSPS_MyRank = "%s-й уровень"
	
	L.CSPS_CP_RED = "Красные ОГ"
	L.CSPS_CP_BLUE = "Синие ОГ"
	L.CSPS_CP_GREEN = "Зелёные ОГ"
	
	L.CSPS_TxtCp = "ОГ"	-- shortest form for champion points
	
	--	Errormessages (chat)
	L.CSPS_NoSavedData = "Нет сохранённых сведений."
	L.CSPS_TxtLangDiff = "Изменён язык интерфейса игры. Мигрирую данные для сортировки типов способностей по названию."
	L.CSPS_Txt_NewProfile = "Профиль №" -- for numbered names
	L.CSPS_Txt_NewProfile2 = "Новый профиль" -- for unnumbered names
	L.CSPS_Txt_StandardProfile = "Стандартный"
	
	L.CSPS_CPP_Name = "Название"
	L.CSPS_CPP_Points = "Очки"
	L.CSPS_CPP_Role = "Роль"
	L.CSPS_CPP_Source = "Источник"
	L.CSPS_CPP_Hotkey = "Клавиша"
	L.CSPS_CPP_BtnCustAcc = "Свой\n(учётка)"
	L.CSPS_CPP_BtnCustChar = "Свой\n(перс)"
	L.CSPS_CPP_BtnImportText = "Импорт из текста"
	L.CSPS_CPP_BtnPresets = "Подборки"
	L.CSPS_CPP_BtnHotBar = "Только панели"
	L.CSPS_CPApplied = "Очки Героя успешно распределены"
	L.CSPS_CPNoChanges = "Очки Героя не требуют изменений"
	L.CSPS_CPBar_GroupHeading = "Текущая группа: %s/%s"
	L.CSPS_CPBar_GroupKeybind = "Текущая клавиша: %s"
	L.CSPS_Manage_Connections = "Управление связями"
	L.CSPS_CPLoadGroup = "Загрузка группы:"
	L.CSPS_CPOldPreset = "Связанные с текущим профилем подборки ОГ помечены как устаревшие. Вы можете и дальше ими пользоваться, но вам следует переключиться на более актуальные."
	L.CSPS_BuildProfile = "Профиль сборки"
	
	L.CSPS_CPValueTooHigh = "Значение превышает максимальное для данной способности."
	
	L.CSPS_CPPDescr_JoaTFarming = "Эта подборка оптимизирована под аддон «Jack of all Trades» и нацелена на сбор материалов (бой, рыбалка и воровство добавляются по ходу повышения уровня ОГ)."
	L.CSPS_CPPDescr_JoaTFishing = "Эта подборка оптимизирована под аддон «Jack of all Trades» и нацелена на рыбалку (бой, сбор и воровство добавляются по ходу повышения уровня ОГ)."
	L.CSPS_CPPDescr_JoaTThieving = "Эта подборка оптимизирована под аддон «Jack of all Trades» и нацелена на воровство (бой, сбор и рыбалка добавляются по ходу повышения уровня ОГ)."
	L.CSPS_CPPDescr_CombatFocus = "Эта сборка нацелена на полезные в бою способности зелёной категории ОГ."
	
	L.CSPS_StrictOrder = "Строгий порядок"
	L.CSPS_Tooltiptext_StrictOrder = "Включите, чтобы аддон остановил загрузку на первой встреченной способности, для которой у вас не хватает очков, и не проверял далее идущие способности на возможность приобретения. В таком случае у вас может оказаться больше незадействованных очков, но также это может в будущем сэкономить вам 3000 золота на сброс."
	L.CSPS_CPPCurrentlyApplied = "Сейчас вложено:  <<1[ничего/$d очко/$d очка/$d очков]>>"
		
	L.CSPS_MSG_ApplyClosing = "Похоже, вы не применили некоторые изменения в Очках Героя. Убедитесь, что вы ничего не забыли."
	
	L.CSPS_CPBar_LocTrial = "Рейд/Арена"
	L.CSPS_CPBar_LocCurr = "Текущая локация"
	L.CSPS_CPBar_LocType = "По типу"
	L.CSPS_CPBar_Location = "Локация"
	
	L.CSPS_CPBar_AddBindings = "Добавьте условия для автоматического применения этой группы..."
	L.CSPS_CPBar_BindingsHeader = "Существующие условия для этой группы:"
	L.CSPS_Bindings_Empty = "Пустая группа"
	L.CSPS_Binding_Overwritten = "Перезаписана: группой %s (%s)"
	L.CSPS_Binding_Conflict = "Конфликт с существующей связью с группой %s.\n|t26:26:esoui/art/miscellaneous/icon_rmb.dds|t: разорвать существующую связь."
	
	L.CSPS_CPBar_EditProfiles = "Редактировать профили"
	L.CSPS_CPBar_Apply = "Загрузить и применить эту группу..."
	L.CSPS_CPBar_NoDR = "У вас либо не установлен «<<1>>», либо ваша версия сейчас не поддерживается."

	L.CSPS_QS_ApplyWait = "Применяется панель: %s (время ожидания: %s)"
	L.CSPS_QS_TT_Edit = "|t26:26:esoui/art/miscellaneous/icon_rmb.dds|t: Изменить"
	L.CSPS_QS_TT_Select = "|t26:26:esoui/art/miscellaneous/icon_lmb.dds|t: Выбрать"
	L.CSPS_QS_TT_TestIt = "|t26:26:esoui/art/miscellaneous/icon_rmb.dds|t: Воспользоваться сейчас"
	L.CSPS_SubProfiles_Edit = "Редактировать подпрофили"
	
	L.CSPS_Help_Oversection1 = "Общие функции"
	L.CSPS_Help_Head1 = "Сохранение сведений о персонаже"
	L.CSPS_Help_Sect1 = "1. Нажмите «Считать сведения с персонажа» (|t24:24:esoui/art/help/help_tabicon_feedback_up.dds|t).\n2. По желанию, понажимайте плюс и минус рядом со способностями, которые хотите настроить (можно отложить на потом.)\n3. Нажмите «Сохранить содержимое окна». (|t24:24:esoui/art/mail/mail_tabicon_compose_up.dds|t)\nВсе способности, характеристики, ОГ, ячейки быстрого доступа и экипировка (если активен LibSets) будут сохранены."
	L.CSPS_Help_Head2 = "Загрузка сохранённых сведений"
	L.CSPS_Help_Sect2 = "1. Нажмите «Загрузить сохранённый профиль». (|t24:24:esoui/art/mail/mail_tabicon_inbox_up.dds|t)\n2. По желанию, понажимайте плюс и минус рядом со способностями, которые хотите настроить.\n3. Нажмите одну из кнопок применения (|t24:24:esoui/art/buttons/accept_up.dds|t) вверху окна или справа от заголовка категории, чтобы применить способности, характеристики и проч.\nВыбранные вами сведения применяются на персонажа.\nПрименяя способности, учтите, что они применяются по отдельности на каждую панель персонажа. Убедитесь, что панели показываются внизу окна аддона. Если их нет, нажмите «Настройки» (верхний правый угол, |t24:24:esoui/art/skillsadvisor/advisor_tabicon_settings_up.dds|t) и включите панели. После этого нажмите «Применить» внизу окна аддона (|t24:24:esoui/art/buttons/accept_up.dds|t)."
	L.CSPS_Help_Head3 = "Создание профилей"
	L.CSPS_Help_Sect3 = "Вы можете сохранить все сведения о персонаже (способности, характеристики, ОГ) в различные профили.\n1. Выберите существующий профиль в выпадающем списке в левом верхнем углу окна аддона либо создайте новый профиль, нажав кнопку-плюс справа от списка профилей.\n2. За вычетом стандартного, вы вольны переименовывать и стирать все созданные вами профили (|t24:24:esoui/art/buttons/edit_up.dds|t , |t24:24:esoui/art/buttons/minus_up.dds|t).\n3. Для сведения к минимуму объёма сохранённых данных рекомендуется сохранять в профиль только те способности, которые будут меняться при его наложении. Пользуйтесь кнопками-минусами для убирания способностей и целых веток из профиля.\n4. Не забудьте сохранить профиль после внесения всех изменений. (|t24:24:esoui/art/mail/mail_tabicon_compose_up.dds|t)"
	L.CSPS_Help_Head4 = "Наложение профилей / перераспределение"
	L.CSPS_Help_Sect4 = "Прежде чем применять профиль с очками способностей и характеристик, сперва посетите алтарь обновления.\nВ большинстве случаев вам нет нужды сбрасывать все способности — сброс преобразований зачастую достаточен. Оставаясь в режиме обновления, примените профиль. Подтвердите изменения в интерфейсе ESO по завершении. Учтите, что аддон будет считать ваши изменения конфликтами, пока игра находится в интерфейсе обновления, и изменения ещё не применены. В качестве альтернативы вы можете бесплатно загружать пустую сборку из арсенала («Мастерская вооружения») перед наложением профиля. Помните, что аддоны не способны менять ваш Камень Мундуса."
	L.CSPS_Help_Head5 = "Уникальные значки ОГ"
	L.CSPS_Help_Sect5 = "Чтобы было проще заметить разницу между активными способностями ОГ, аддон может заменить их значки на нестандартные. Нажмите «Настройки» (верхний правый угол, |t24:24:esoui/art/skillsadvisor/advisor_tabicon_settings_up.dds|t) и включите параметр «Уникальные значки ОГ»."
	L.CSPS_Help_Head6 = "Отделённая панель героя"
	L.CSPS_Help_Sect6 = "Аддон может показывать выставленные способности ОГ на отдельной панели во время управления персонажем, чтобы было проще посмотреть, какие из них сейчас применяются. Нажмите «Настройки» (верхний правый угол, |t24:24:esoui/art/skillsadvisor/advisor_tabicon_settings_up.dds|t) и включите параметр «Отдельная панель ОГ». Здесь вы также можете выбрать, показывать ли панель совмещённой (1 по 12), в три колонки (3 по 4), либо только зёленую ветку (1 по 4)."
	L.CSPS_Help_Oversection7 = "Подпрофили"
	L.CSPS_Help_Head7 = "Подпрофили в общих чертах"
	L.CSPS_Help_Sect7 = "У вас есть возможность создавать отдельные подпрофили для таких дисциплин профиля как способности, панели быстрого доступа и Очки Героя.\n1. Нажмите на одну из кнопок в верхней правой части окна, в зависимости от желаемой дисциплины (|t24:24:esoui/art/champion/champion_points_magicka_icon-hud-32.dds|t, |t24:24:esoui/art/champion/champion_points_health_icon-hud-32.dds|t, |t24:24:esoui/art/champion/champion_points_stamina_icon-hud-32.dds|t ...).\n2. Выберите, сохранить ли подпрофиль только для этого персонажа, или же сделать его доступным на всю учётную запись.\n3. Для Очков Героя вы вместо собственных настроек можете загрузить готовые подборки, поставляемые вместе с аддоном." 
	L.CSPS_Help_Head8 = "Автоматизация (связь групп)" 
	L.CSPS_Help_Sect8 = "Вы можете создавать связанные группы, которые загружаются по клавише либо автоматически, в том числе, профили панели героя и панели быстрого доступа. Вы также можете загружать профили сборки целиком, но так делать не рекомендуется, потому что с вас может списать золото, или может произойти ошибка наложения профиля. Отвечающий за такой режим параметр надо дополнительно включать в настройках. Вы можете задать до 20 групп для всей учётной записи и 20 групп на каждого персонажа. Каждой группе можно назначить клавишу в настройках управления игрой. Если аддон обнаруживает группу для учётки и группу для персонажа под одним и тем же номером, то всегда грузит группу для персонажа." 
	L.CSPS_Help_Head9 = "Установка связанных групп"
	L.CSPS_Help_Sect9 = "1. Для установки автоматизации нажмите «Настройки». (|t24:24:esoui/art/skillsadvisor/advisor_tabicon_settings_up.dds|t)\n2. Нажмите «Управление связями».\n3. При помощи стрелок вверху |t24:24:esoui/art/buttons/large_leftarrow_up.dds|t и |t24:24:esoui/art/buttons/large_rightarrow_up.dds|t выберите группу.\n4. Выбранные подпрофили теперь можно загружать и применять по настроенной клавише или по одному из автоматических сценариев, о которых написано дальше."
	L.CSPS_Help_Head10 = "Связь с локациями"
	L.CSPS_Help_Sect10 = "В окне управления связями вы можете настроить, чтобы связанная группа применялась при посещении выбранной локации, например, указанного рейда (Испытания) или арены.\n	1. Нажмите «Локация».\n  2. Выберите ту локацию, где выбранная группа должна автоматически применяться, например, «Солнечный шпиль». \n 3. Отныне аддон будет накладывать выбранные вами подпрофили после загрузки внутрь рейда Солнечный шпиль."
	L.CSPS_Help_Head11 = "Dressing Room/Alpha Gear/Wizard's Wardrobe"
	L.CSPS_Help_Sect11 = "Вы также можете связать группы со сборками в Dressing Room, Alpha Gear или Wizard's Wardrobe через окно управления связями.\n1. Нажмите «DR», «AG» или «WW».\n2. Выберите набор экипировки или способностей, с которым вы желаете связать свой профиль Очков Героя.\n3. Отныне каждый раз, когда вы надеваете этот набор в Dressing Room, Alpha Gear или Wizard's Wardrobe, заодно применится и связанная группа."
	L.CSPS_Help_Oversection12 = "Импорт/\nЭкспорт"
	L.CSPS_Help_Head12 = "Импорт/экспорт в общих чертах"
	L.CSPS_Help_Sect12 = "1. Нажмите «Настройки». (|t24:24:esoui/art/skillsadvisor/advisor_tabicon_settings_up.dds|t)\n2. Нажмите «Import/Export». Откроется окно импорта/экспорта.\n3. Через меню в верхнем правом углу выберите сведения и формат импорта и/или экспорта.\n4. В зависимости от выбранного формата у вас появятся соответствующие варианты настроек.\n5. Для импорта сведений вы сначала должны скопировать их в буфер, а затем вставить в текстовое поле импорта (Ctrl+V)."
	L.CSPS_Help_Head13 = "Импорт Очков Героя из текста (1 из 3)"
	L.CSPS_Help_Sect13 = "1. Для этого варианта выберите, какую ветку способностей вы желаете импортировать.\n2. Текст импорта должен содержать (английские) названия способностей героя и соответствующие им числовые значения.\n3. Стандартный формат — число очков, затем название способности (напр. «10 Tireless Discipline» или «(10) → Tireless Discipline»). Вы можете изменить этот порядок, отметив флажок в нижней части окна. Учтите, что в тексте не должно быть никаких чисел кроме количества очков для каждой способности (если вы пытаетесь импортировать с сайта AlcastHQ, в тексте могут быть диапазоны вроде «0-120» — нажмите «Почистить текст» в нижнем правом углу, чтобы от них избавиться)."
	L.CSPS_Help_Head14 = "Импорт Очков Героя из текста (2 из 3)"
	L.CSPS_Help_Sect14 = "4. Если в тексте есть активные способности ОГ, аддон будет выставлять их сверху вниз. Если вы хотите выставить только некоторые способности, пометьте их дополнительной надписью «slot» (надо вписать после названия, а не после числа).\n5. Если аддон не определит какие-то способности по названию, у вас будет возможность выбрать их вручную из списка. Процесс не закончится до тех пор, пока все значения не будут приняты либо отброшены."
	L.CSPS_Help_Head15 = "Импорт Очков Героя из текста (3 из 3)"
	L.CSPS_Help_Sect15 = "Если в вашем тексте встречается несколько чисел для той же способности, будет взято только последнее. Удерживайте Shift при нажатии «Импорт», чтобы вместо этого их просуммировать.\nПравой кнопкой мыши вы можете создать динамический профиль, а удержанием Ctrl — сделать общим на учётку. Очки Героя в динамическом профиле будут накладываться сверху вниз, пока не будет достигнут максимальный на данный момент уровень."
	L.CSPS_Help_Head16 = "Пошагово — импорт с AlcastHQ или JustLootIt"
	L.CSPS_Help_Sect16 = "1. Нажмите значок синих, красных или зелёных ОГ в правом верхнем углу (в зависимости от желаемой ветки).\n2. Нажмите «Импорт из текста» (Ctrl+V).\n3. Вставьте кусок текста из сайта в текстовое поле импорта.\n4. Удостоверьтесь, что слово «slot» стоит только после тех способностей, которые вы хотите иметь на панели.\n5. Нажмите «Почистить текст» внизу справа.\n6. Включите флажок «Обратный порядок» (ибо и AlcastHQ и JustLootIt пишут название перед числом).\n7. Нажмите «Импорт текста».\n8. ОГ теперь загружены в аддон. Вы можете либо сохранить их в новый профиль «Свой (учётка)» или «Свой (перс)» и затем нажать кнопку-плюс под этими кнопками, либо же наложить их кнопкой «Применить» под разделом профиля ОГ."
	
	-- Dialogs
	L.CSPS_MSG_ConfirmSave = "Действительно сохранить показанные сведения в профиль «<<1>>»? Существующие данные будут перезаписаны.<<2>>"
	L.CSPS_MSG_ConfirmApply = "Доступно очков навыков: %s\nНужно очков навыков: %s\n\nКонфликтов: %s\nНе разблокировано: %s\nСтоит не то преобразование: %s\nУровень уже выше: %s\nПреобр./уровень не доступен: %s\n\nПрименить способности?"
	L.CSPS_MSG_ConfirmApplyTitle = "CSPS — Очки навыков"
	L.CSPS_MSG_ConfirmAttrTitle = "CSPS — Очки характеристик"
	L.CSPS_MSG_ConfirmAttr = "Нужно очков характеристик: <<1>>\nДоступно очков характеристик: <<2>>\nПрименить характеристики?"
	L.CSPS_MSG_ConfirmAttr1 = "Не удалось вложить очки характеристик — очков не хватает. Сперва сделайте сброс характеристик персонажа."
	L.CSPS_MSG_ConfirmAttr2 = "Не удалось вложить очки характеристик — минимум одна характеристика прокачана выше установленного значения. Сперва сделайте сброс характеристик персонажа."	
	L.CSPS_MSG_RenameProfile = "Введите новое название для профиля «<<1>>»:<<2>>"
	L.CSPS_MSG_DeleteProfile = "Действительно стереть профиль «<<1>>»? <<2>><<3>>"
	L.CSPS_MSG_DeleteProfileStan =  "Вместо этого будет загружен стандартный профиль."
	L.CSPS_MSG__ChangeProfile = "Профиль «<<1>>» возможно содержит несохранённые изменения. Действительно загрузить профиль «<<2>>»?<<3>>"
	L.CSPS_MSG_DeleteSkillType = "Действительно хотите убрать все способности «<<1>>» из этого профиля?" -- <<1>> can either be a skill type or a skill line 
	L.CSPS_MSG_CpPurchTitle = "Вложение Очков Героя..."
	L.CSPS_MSG_CpPurchChosen = "Необходимо очков: "
	L.CSPS_MSG_CpPurchCost = "Затраты: <<1>>|t28:28:esoui/art/loot/icon_goldcoin_pressed.dds|t" -- the cost and a coin-icon
	L.CSPS_MSG_CpPurchNow = "Действительно хотите применить сейчас выбранные Очки Героя?"
	L.CSPS_MSG_CpPurchFailed = "Сбой при вложении Очков Героя."
	L.CSPS_MSG_CpPurchSuccess = "Очки Героя успешно вложены."
	L.CSPS_MSG_CpPointsMissing = "У вас недостаточно Очков Героя — уберите их и попытайтесь снова."
	L.CSPS_MSG_Unslotted = "Следующие способности не удалось выставить на панель:"
	L.CSPS_MSG_NoCPProfiles = "\n\n|cff7723ВНИМАНИЕ!|r\nЭто не лучший способ хранить профили ОГ! Если вы хотите сохранить профиль только лишь Очков Героя, воспользуйтесь тремя кнопками сверху справа, чтобы открыть раздел Очков Героя. Там вы найдёте отдельные кнопки для создания и сохранения профилей. (|t28:28:esoui/art/champion/champion_points_magicka_icon-hud-32.dds|t, |t28:28:esoui/art/champion/champion_points_health_icon-hud-32.dds|t, |t28:28:esoui/art/champion/champion_points_stamina_icon-hud-32.dds|t)"
	L.CSPS_MSG_CPPaths = "Самые дешёвые пути к открытию «<<C:1>>»:\n\n<<2>>"
	L.CSPS_MSG_CPPathOpt = "|c<<1>><<2>>-й вариант (<<3>>)|r:" -- 1 color 2 number 3 points
	
	--	Errorcodes
	L.CSPS_ErrorNumber1 = "Эта способность уже изучена."
	L.CSPS_ErrorNumber2 = "Эта способность уже преобразована иначе. Сбросьте, пожалуйста, способности или преобразования, прежде чем приобретать новые."
	L.CSPS_ErrorNumber3 = "Текущий уровень способности превышает установленный вами."
	L.CSPS_LoadingError = "См. способность / Please check skill: <<C:1>>"
	
	-- Options
	L.CSPS_KeepLastBuild = "Хранить посл. сборку по закрытии"
	L.CSPS_KeepLastBuildTT = "Если включено, аддон будет сохранять параметры сборки в невидимый профиль каждый раз, когда вы закрываете окно. Этот профиль загрузится в следующий раз, когда вы запустите игру и откроете аддон, чтобы продолжить с того места, где вы закончили. Если отключено, аддон всегда покажет при запуске текущее состояние персонажа."
	L.CSPS_DeleteLastBuilds = "Следует ли стереть временные профили на всех персонажах?"
	L.CSPS_ShowHb = "Показать панель"
	L.CSPS_AutoOpen = "Автоматически показывать, если..."
	L.CSPS_CPAutoOpen = "Открыт экран ОГ"
	L.CSPS_CPCustomBar = "Отдельная панель ОГ"
	L.CSPS_CPCustomIcons = "Уникальные значки ОГ"
	L.CSPS_CPCustomBarLayout = "Отображение"
	L.CSPS_ArmoryAutoOpen = "Открыт арсенал (мастерская вооружения)"
	L.CSPS_Tooltip_ArmoryAutoOpen = "Включите, чтобы аддон автоматически открывался при вызове арсенала («мастерской вооружения»)."
	L.CSPS_SkillWindowAutoOpen = "Открыто меню способностей"
	L.CSPS_StatsWindowAutoOpen = "Открыто меню персонажа"
	L.CSPS_BtnApplyAll = "Применить всё"
	L.CSPS_ShowBtnApplyAll = "Показывать кнопку «Применить всё»"
	L.CSPS_ShowDateInProfileName = "Показывать дату изменения в названии профиля"
	L.CSPS_AcceptedLevelDifference = "Допустимая разница в уровне"
	L.CSPS_AcceptedLevelDifferenceTooltip = "CSPS будет искать и экипировать только те предметы, которые отличаются по уровню от вашего персонажа на меньшее количество, чем здесь задано."
	L.CSPS_RequiresLibSets = "Эта функция работает только при наличии LibSets."
	L.CSPS_ShowGearMarkers = "Показывать маркеры в инвентаре"
	L.CSPS_ShowGearMarkersTooltip = "Маркеры будут показаны только у предметов, соответствующих сохранённым профилям. Сохраните текущий профиль после изменений, чтобы отметить соответствующие ему предметы из наборов."
	L.CSPS_ShowGearMarkerDataBased = "Показывать маркеры у подходящих предметов"
	L.CSPS_ShowGearMarkerDataBasedTooltip = "Если предметы хранятся по признакам вместо уникальных идентификаторов, аддон может отмечать подходящие под описание предметы. В противном случае будут отмечены только конкретные указанные предметы."
	L.CSPS_SavedSpecific = "Сохранено в: %s"
	L.CSPS_SavedData = "Подходит к: %s"
	
	L.CSPS_LAM_ShowCpPresetNotifications = "Уведомлять при загрузке подборок ОГ"
	L.CSPS_LAM_ShowCpNotSaved = "Изменения в Очках Героя ещё не применялись"
	L.CSPS_LAM_ShowSaveOther = "Сохрание общего профиля при открытом разделе подпрофиля"
	L.CSPS_LAM_KB_Descr = "Вы можете скомбинировать подпрофили в группу, применяемую по клавише. Вам доступны 20 групп на учётную запись и по 20 на каждого персонажа. Вы можете настроить до 20 клавиш, чтобы быстро переключаться между группами. Нажатие клавиши загрузит группу для персонажа, если она не пустая. В противном случае будет загружена группа для учётной записи под тем же номером. Вы можете настроить отдельную клавишу для принудительной загрузки группы для учётной записи вместо группы для персонажа."
	L.CSPS_LAM_KB_ShiftMode = "Клавиша для принудительной загрузки группы для учётки вместо группы для персонажа"
	L.CSPS_LAM_ShowOutdatedPresets = "Показ. устаревшие подборки в списке профилей"
	L.CSPS_LAM_ShowBindBuild = "Показ. профили сборок в управлении связями (учтите: автоматизация может не сработать для профиля, которому требуется сброс очков через алтарь)"
	L.CSPS_LAM_JumpShiftKey = "Клавиша для пропуска 10 очков при выставлении значений и для связи подпрофилей с профилями сборок"
	L.CSPS_LAM_SortCP = "Порядок Очков Героя"
	L.CSPS_LAM_SortCP_1 = "Стандартный"
	L.CSPS_LAM_SortCP_2 = "По названию"
	L.CSPS_LAM_SortCP_3 = "По названию, пассивные отдельно"
	L.CSPS_LAM_ShowNumSetItems = "Показывать число активных предметов набора после его названия. Число будет в виде «(главная/вспомогательная панель)» для оружейных ячеек."
	
	-- Presets
	L.CSPS_MSG_SwitchCP = "Вложите очки в |c<<1>>«<<2>>»|r вместо одной из других выставляемых способностей, когда это начнёт давать эффект."
	L.CSPS_MSG_SituationalCP = "Постарайтесь заменять способности на панели одной из следующих, когда это требуется по ситуации:"
	L.CSPS_CPP_Tank = "Танк"
	L.CSPS_AOE = "AoE-урон"
	L.CSPS_CRIT = "Крит. урон"
	L.CSPS_OffBalance = "Вне равновесия"
	
	-- Import/Export
	L.CSPS_ImpEx_BtnImpLink = "Импорт ссылки"
	L.CSPS_ImpEx_BtnImpText = "Импорт текста"
	L.CSPS_ImpEx_BtnExpLink = "Создать ссылку"
	L.CSPS_ImpEx_BtnExpText = "Создать текст"
	L.CSPS_ImpEx_Standard = "Вы можете либо вставить ссылку (Ctrl+V) с eso-skillfactory.com для импорта сборки, либо нажать «Создать ссылку», чтобы построить ссылку для текущего выбранного профиля, скопировать её (Ctrl+C) и вставить в браузер, чтобы просмотреть на eso-skillfactory.com."
	L.CSPS_ImpEx_CpAsText = "Вы можете вставить сборку ОГ в текстовом виде в это поле (Ctrl+V). Стандартный формат: число для каждого значения, а затем название способности. Если в импортируемом вами тексте другой порядок, включите «Обратный порядок» внизу. Если в тексте есть диапазоны ОГ (как у AlcastHQ и JustLootIt), нажмите «Почистить текст» внизу, чтобы их убрать. После этого нажмите «Импорт текста». Если имена всех способностей записаны верно и полностью, аддон автоматически внесёт их в таблицу для проверки и применения."
	L.CSPS_ImpEx_BtnImpTT = "Сперва вставьте (Ctrl+V) ссылку в поле ниже."
	L.CSPS_ImpEx_BtnImpTTCP = "Сперва вставьте (Ctrl+V) текст в поле ниже.\nУдерживайте Ctrl, чтобы создать код для подборки.\nНажмите правую кнопку, чтобы создать динамический профиль, а с удерживанием Ctrl — общий на учётную запись.\nПри нажатии Shift несколько значений одной и той же способности ОГ будут суммироваться, а не отбрасываться."
	L.CSPS_ImpEx_BtnExpTT = "Построить ссылку из текущей показанной сборки."
	L.CSPS_ImpEx_NoData = "Сведения не найдены. Сперва загрузите сведения персонажа, а потом уже создавайте ссылку."
	L.CSPS_ImpEx_ErrHb = "Ошибка импорта для панели <<1>>."
	L.CSPS_ImpEx_ErrSk = "Не удалось найти способность: <<1>>."
	L.CSPS_ImpExp_TextSk = "Экспорт текста"
	L.CSPS_ImpExp_TextOd = "Другие данные"
	L.CSPS_ImpEx_HbTxt = "Панель"
	L.CSPS_ImpEx_CsvCP = "Список ОГ через запятую"
	L.CSPS_ImpEx_TxtCP2_1 = "ОГ |cA6D852(зелёные, из текста)|r" 
	L.CSPS_ImpEx_TxtCP2_2 = "ОГ |c5CBDE7(синие, из текста)|r" 
	L.CSPS_ImpEx_TxtCP2_3 = "ОГ |cDE6531(красные, из текста)|r"
	L.CSPS_ImpExp_TxtOrder1 = "Число → Назв.(/Slot)"
	L.CSPS_ImpExp_TxtOrder2 = "Назв.(/Slot)→Число"
	L.CSPS_ImpExp_TxtOrder3 = "Назв.→Число(→Slot)"
	L.CSPS_ImpEx_CapLabel = "Лимит очков"
	L.CSPS_ImpEx_LangTT = "Использовать %s вместо английского как язык для названий способностей ОГ (не включайте, если хотите импортировать ОГ с английских сайтов)"
	L.CSPS_ImpExp_CleanUp = "Почистить текст"
	L.CSPS_ImpExp_Transfer = "Перенести..."
	L.CSPS_ImpExp_TransferLoad = "Загрузить"
	L.CSPS_ImpExp_TransConfirm = "|cDE6531Действительно перенести все связи с <<1>> на <<2>>? Все текущие связи будут необратимо перезаписаны.|r"
	L.CSPS_ImpExp_Transfer_Server = "Сервер"
	L.CSPS_ImpExp_Transfer_Profiles = "Профиль..."
	L.CSPS_ImpExp_Transfer_CPP = "Профиль ОГ..."
	L.CSPS_ImpExp_Transfer_CPHb = "Панель ОГ..."
	L.CSPS_ImpExp_Transfer_CopyReplace = "Перенести все профили панели и связи (заменив текущие профили)"
	L.CSPS_ImpExp_Transfer_CopyAdd = "Перенести все профили панели и связи (не трогая текущие профили)"
	
	L.CSPS_Tooltip_Transfer_CopyReplace = "|cDE6531Все связи и профили панелей, настроенные для этого персонажа, будут перезаписаны.|r"
	L.CSPS_Tooltip_Transfer_CopyAdd = "Перенести профили панелей, не трогая уже существующие.\n|cDE6531Все связи, настроенные для этого персонажа, будут перезаписаны.|r"
	
	L.CSPS_CPImp_Success = "Успешно найденные способности:"
	L.CSPS_CPImp_Unmapped = "Не назначенные способности:"
	L.CSPS_CPImp_BtnApply = "Соотнести"
	L.CSPS_CPImp_BtnDiscard = "Отбросить"
	L.CSPS_CPImp_BtnDiscardAll = "Отбросить все"
	L.CSPS_CPImp_New = "|c<<1>> <<2>>/<<3>> Соотнести <<4[$d очков/$d очко/$d очка/$d очков]>> с: <<C:5>>|r" -- 1 color 2 index 3 lastIndex 4 points 5 name
	L.CSPS_CPImp_Note = "Нажмите способность в списке ниже, чтобы соотнести очки с нею. Учтите, что применить установленные значения вы сможете только после того, как соотнесёте или отбросите все неназначенные способности."
	L.CSPS_CPImp_NoMatch = "Не удалось найти соответствующие данные."
	
for stringId, stringValue in pairs(L) do
	ZO_CreateStringId(stringId, stringValue)
end