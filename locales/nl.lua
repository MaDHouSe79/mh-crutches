local Translations = {
    info = {
        ['ragdoll'] = "Je kunt geen kruk gebruiken als je in de ragdoll zit!",
        ['falling'] = "Je kunt geen kruk gebruiken als je valt!",
        ['combat'] = "Je kunt geen kruk gebruiken tijdens een gevecht!",
        ['dead'] = "Je kunt geen kruk gebruiken als je dood bent!",
        ['vehicle'] = "U kunt geen kruk gebruiken terwijl u in een voertuig zit!",
        ['weapon'] = "Je kunt geen kruk gebruiken terwijl je een wapen hebt!",
        ['pickup'] = "Druk ~INPUT_PICKUP~ om je kruk op te pakken!"
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})