local Translations = {
    info = {
        ['ragdoll'] = "You can't use a crutch while you are in ragdoll!",
        ['falling'] = "You can't use a crutch while you are falling!",
        ['combat'] = "You can't use a crutch while you are in combat!",
        ['dead'] = "You can't use a crutch while you are dead!",
        ['vehicle'] = "You can't use a crutch while you are in a vehicle!",
        ['weapon'] = "You can't use a crutch while having a weapon out!",
        ['pickup'] = "Press ~INPUT_PICKUP~ to pick up your crutch!"
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})