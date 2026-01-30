#!/bin/bash

# Carregar cores e configurações
source "$CONFIG_DIR/colors.sh"

# Obtém info da bateria
BATT_INFO=$(pmset -g batt)

# Extrai a porcentagem (apenas números)
PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "[0-9]+%" | tr -d '%')
IS_CHARGING=$(echo "$BATT_INFO" | grep "AC Power")

# Fallback para caso não consiga ler a porcentagem
if [ -z "$PERCENTAGE" ]; then
	PERCENTAGE=0
fi

# 1. Lógica de Ícones e Cores (Igual ao seu Lua)
COLOR="$WHITE"

if [ -n "$IS_CHARGING" ]; then
	ICON="􀢋" # icons.battery.charging
else
	if [ "$PERCENTAGE" -gt 80 ]; then
		ICON="􀛨" # icons.battery._100
	elif [ "$PERCENTAGE" -gt 60 ]; then
		ICON="􀺸" # icons.battery._75
	elif [ "$PERCENTAGE" -gt 40 ]; then
		ICON="􀺶" # icons.battery._50
	elif [ "$PERCENTAGE" -gt 20 ]; then
		ICON="􀛩" # icons.battery._25
		COLOR="$WHITE"
	else
		ICON="􀛪" # icons.battery._0
		COLOR="$RED"
	fi
fi

# 2. Formatação do Label (Adiciona o "0" se < 10, igual à variável 'lead' do Lua)
LABEL="${PERCENTAGE}%"
if [ "$PERCENTAGE" -lt 10 ]; then
	LABEL="0${PERCENTAGE}%"
fi

# 3. Atualização do SketchyBar
sketchybar --set "$NAME" \
	icon="$ICON" \
	icon.font="JetBrainsMono Nerd Font:Bold:10.0" \
	label="$LABEL" \
	label.color="$COLOR"
