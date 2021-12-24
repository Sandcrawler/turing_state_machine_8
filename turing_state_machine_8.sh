#!/bin/bash

typeset -A c
c[A0]="10C"
c[A1]="10C"
c[B0]="10D"
c[B1]="01D"
c[C0]="10B"
c[C1]="01B"
c[D0]="11A"
c[D1]="01H"
typeset -r c

typeset -a a=([1]=0 [2]=0 [3]=0 [4]=0 [5]=0 [6]=0 [7]=0 [8]=0 [9]=0)
typeset -a b=([1]=0 [2]=0 [3]=0 [4]=0 [5]=0 [6]=0 [7]=0 [8]=0 [9]=0)
typeset -a res=([1]=0 [2]=0 [3]=0 [4]=0 [5]=0 [6]=0 [7]=0 [8]=0)
typeset -a ress
typeset -a resss
typeset p=5
typeset l=0
typeset x=""
typeset i="00A"
typeset st=0
typeset et=0
typeset tt=0
typeset z=0
typeset z0=0
typeset z1=0
typeset z2=0
typeset z3=0
typeset z4

tur(){
	st=$(date +%s)
	while [ ${i:2:1} != H ]; do
		x=${i:2:1}${a[${p}]:-0}
		i=${c[${x}]}
		a[${p}]=${i:0:1}
		if [ ${i:1:1} == 0 ]; then
			# forward
			z0=${#a[@]}
			z1=$((${z0}-1))
			while [[ ${z0} != 0 ]]; do
				if [[ ${a[${z1}]} =~ ^0|1$ ]]; then
					a[${z0}]=${a[${z1}]}
				fi
				((z0--))
				((z1--))
			done
			# inverse
			for z0 in $(seq 1 ${#a[@]}); do
				z1=$((${#a[@]}-${z0}+1))
				b[${z1}]=${a[${z0}]}
			done
		else
			# forward
			z0=1
			z1=$((${z0}+1))
			z2=${#a[@]}
			while [[ ${z0} != ${z2} ]]; do
				if [[ ${a[${z1}]} =~ ^0|1$ ]]; then
					a[${z0}]=${a[${z1}]}
				fi
				((z0++))
				((z1++))
			done
			# inverse
			for z0 in $(seq 1 ${#a[@]}); do
				z1=$((${#a[@]}-${z0}+1))
				b[${z1}]=${a[${z0}]}
			done
		fi
		for z0 in $(seq 1 ${#res[@]}); do
			z1=$((${z0}+1))
			if [[ ! ${a[${z0}]} =~ ^[0-9]$ ]]; then
				res[${z0}]=$((${b[${z1}]}))
			elif [[ ! ${b[${z1}]} =~ ^[0-9]$ ]]; then
				res[${z0}]=$((${a[${z0}]}))
			else
				res[${z0}]=$((${a[${z0}]}+${b[${z1}]}))
			fi
		done
		((l++))
		ress[${l}]=${res[@]}
	done
	for z0 in $(seq 1 ${l}); do
		z1=$((${l}-${z0}+1))
		z=1
		for z2 in ${ress[${z0}]}; do
			z3=$(echo ${ress[${z1}]} | cut -d' ' -f${z} 2>/dev/null)
			z2=$((${z2}+${z3}))
			z4=(${z4[@]} ${z2})
			((z++))
		done
		resss[${z0}]=${z4[@]}
		echo "${ress[${z0}]}  +  ${ress[${z1}]}  =  ${resss[${z0}]}"
		unset z4
	done
	et=$(date +%s)
	tt=$((${et}-${st}))
}

tur
exit 0;
