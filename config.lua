Config = {}
Config.Traders = {
    {
        npcLabel = "1111111", 
        npcModel = "s_m_y_dealer_01", 
        coords = vector4(-175.19, 6150.73, 42.64, 135.4),
        drawText = "SARUHANIN AMCASININ OGLU",  
        jobAccess = {}, -- Bu NPC ile sadece bu meslekler etkileşime girebilir. Herkes için boş bırakın: {}
        trades = {
            {
                label = "Varili Doldur",
                requiredItem = "bosbidon", 
                requiredAmount = 2,      
                receivedItem = "hydrochloric_acid",    
                receivedAmount = 1        
            },
        }
    },
    {
        npcLabel = "1111111111",
        npcModel = "s_m_m_autoshop_01",
        coords = vector4(2723.6, 1577.82, 20.82, 165.36),
        drawText = "SARUHANIN DAYİSİNİN OGLU",
        jobAccess = {}, -- Bu NPC ile sadece bu meslekler etkileşime girebilir. Herkes için boş bırakın: {}
        trades = {
            {
                label = "Silah Takasi",
                requiredItem = "weapon_ceramicpistol",
                requiredAmount = 3,
                receivedItem = "weapon_g17",
                receivedAmount = 1
            },
            
        }
    }
}

Config.Animation = {
    dict = "mp_common", -- Animasyon sözlüğü
    name = "givetake1_a", -- Animasyon adı
    duration = 2000 -- Animasyonun milisaniye cinsinden süresi
}