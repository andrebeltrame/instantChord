{
 "patcher": {
  "fileversion": 1,
  "appversion": {
   "major": 8,
   "minor": 1,
   "revision": 2,
   "architecture": "x64",
   "modernui": 1
  },
  "classnamespace": "box",
  "rect": [
   65.0,
   100.0,
   700.0,
   560.0
  ],
  "openrect": [
   0.0,
   0.0,
   616.0,
   148.0
  ],
  "bglocked": 0,
  "openinpresentation": 1,
  "default_fontsize": 12.0,
  "default_fontface": 0,
  "default_fontname": "Arial",
  "gridonopen": 1,
  "gridsize": [
   15.0,
   15.0
  ],
  "gridsnaponopen": 1,
  "objectsnaponopen": 1,
  "statusbarvisible": 2,
  "toolbarvisible": 1,
  "lefttoolbarpinned": 0,
  "toptoolbarpinned": 0,
  "righttoolbarpinned": 0,
  "bottomtoolbarpinned": 0,
  "toolbars_unpinned_last_save": 0,
  "tallnewobj": 0,
  "boxanimatetime": 200,
  "enablehscroll": 1,
  "enablevscroll": 1,
  "devicewidth": 0.0,
  "description": "Gerador de progressões — digite as cifras e escreva no clip",
  "digest": "",
  "tags": "",
  "style": "",
  "subpatcher_template": "",
  "assistshowspatchername": 0,
  "boxes": [
   {
    "box": {
     "id": "obj-1",
     "maxclass": "newobj",
     "text": "js instantchord.js @autowatch 1",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "patching_rect": [
      420.0,
      300.0,
      200.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "newobj",
     "text": "midiin",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      20.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "newobj",
     "text": "midiout",
     "numinlets": 1,
     "numoutlets": 0,
     "outlettype": [],
     "patching_rect": [
      30.0,
      50.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "newobj",
     "text": "midiformat",
     "numinlets": 8,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      80.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "comment",
     "text": "CIFRAS",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      30.0,
      110.0,
      60.0,
      20.0
     ],
     "fontsize": 9.0,
     "presentation": 1,
     "presentation_rect": [
      8.0,
      5.0,
      60.0,
      12.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "textedit",
     "outputmode": 1,
     "bangmode": 1,
     "numinlets": 1,
     "numoutlets": 4,
     "outlettype": [
      "",
      "int",
      "",
      ""
     ],
     "parameter_enable": 0,
     "tabmode": 0,
     "fontsize": 13.0,
     "fontname": "Ableton Sans Medium",
     "text": "Fm Eb Db Ab",
     "bgcolor": [
      0.13,
      0.13,
      0.13,
      1.0
     ],
     "textcolor": [
      0.85,
      0.85,
      0.85,
      1.0
     ],
     "bordercolor": [
      0.29,
      0.29,
      0.29,
      1.0
     ],
     "patching_rect": [
      30.0,
      140.0,
      300.0,
      24.0
     ],
     "presentation": 1,
     "presentation_rect": [
      8.0,
      19.0,
      300.0,
      24.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "newobj",
     "text": "prepend cifras",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      170.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      200.0,
      70.0,
      20.0
     ],
     "varname": "Escrever",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "Escrever no clip",
        "Escrever no clip"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Escrever",
       "parameter_shortname": "Escrever no clip",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      314.0,
      19.0,
      118.0,
      24.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "newobj",
     "text": "prepend escrever",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      230.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      260.0,
      70.0,
      20.0
     ],
     "varname": "Ouvir",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "Ouvir",
        "Ouvir"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Ouvir",
       "parameter_shortname": "Ouvir",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      436.0,
      19.0,
      56.0,
      24.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "newobj",
     "text": "prepend tocar",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      290.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      320.0,
      70.0,
      20.0
     ],
     "varname": "Parar",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "Parar",
        "Parar"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Parar",
       "parameter_shortname": "Parar",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      496.0,
      19.0,
      52.0,
      24.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-13",
     "maxclass": "newobj",
     "text": "prepend parar",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      350.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-14",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      380.0,
      70.0,
      20.0
     ],
     "varname": "Variar",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "Variar",
        "Variar"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Variar",
       "parameter_shortname": "Variar",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      552.0,
      19.0,
      56.0,
      24.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-15",
     "maxclass": "newobj",
     "text": "prepend variar",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      410.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-16",
     "maxclass": "comment",
     "text": "—",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      30.0,
      440.0,
      130.0,
      20.0
     ],
     "fontsize": 11.0,
     "presentation": 1,
     "presentation_rect": [
      8.0,
      51.0,
      120.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-17",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      470.0,
      70.0,
      20.0
     ],
     "varname": "Relativa",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "relativa",
        "relativa"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Relativa",
       "parameter_shortname": "relativa",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      132.0,
      49.0,
      76.0,
      20.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-18",
     "maxclass": "newobj",
     "text": "prepend relativa",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      500.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-19",
     "maxclass": "comment",
     "text": "—",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      30.0,
      530.0,
      380.0,
      20.0
     ],
     "fontsize": 11.0,
     "presentation": 1,
     "presentation_rect": [
      216.0,
      51.0,
      392.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "newobj",
     "text": "route tom cifras info",
     "numinlets": 1,
     "numoutlets": 4,
     "outlettype": [
      "",
      "",
      "",
      ""
     ],
     "patching_rect": [
      30.0,
      560.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-21",
     "maxclass": "newobj",
     "text": "prepend set",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      590.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-22",
     "maxclass": "newobj",
     "text": "prepend set",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      620.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-23",
     "maxclass": "newobj",
     "text": "prepend set",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      650.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-24",
     "maxclass": "live.dial",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      680.0,
      48.0,
      48.0
     ],
     "varname": "Toque",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        0.0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Toque",
       "parameter_shortname": "Toque",
       "parameter_mmin": 0.0,
       "parameter_mmax": 1.0,
       "parameter_modmode": 0,
       "parameter_type": 0,
       "parameter_unitstyle": 1
      }
     },
     "presentation": 1,
     "presentation_rect": [
      8.0,
      74.0,
      48.0,
      48.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-25",
     "maxclass": "newobj",
     "text": "prepend toque",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      710.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-26",
     "maxclass": "live.dial",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      740.0,
      48.0,
      48.0
     ],
     "varname": "Abertura",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        0.0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Abertura",
       "parameter_shortname": "Abertura",
       "parameter_mmin": 0.0,
       "parameter_mmax": 1.0,
       "parameter_modmode": 0,
       "parameter_type": 0,
       "parameter_unitstyle": 1
      }
     },
     "presentation": 1,
     "presentation_rect": [
      66.0,
      74.0,
      48.0,
      48.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-27",
     "maxclass": "newobj",
     "text": "prepend abertura",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      770.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-28",
     "maxclass": "live.dial",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      800.0,
      48.0,
      48.0
     ],
     "varname": "Ritmo",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        0.08
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Ritmo",
       "parameter_shortname": "Ritmo",
       "parameter_mmin": 0.0,
       "parameter_mmax": 1.0,
       "parameter_modmode": 0,
       "parameter_type": 0,
       "parameter_unitstyle": 1
      }
     },
     "presentation": 1,
     "presentation_rect": [
      124.0,
      74.0,
      48.0,
      48.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-29",
     "maxclass": "newobj",
     "text": "prepend ritmo",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      830.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-30",
     "maxclass": "live.dial",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      860.0,
      48.0,
      48.0
     ],
     "varname": "Gate",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        0.7
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Gate",
       "parameter_shortname": "Gate",
       "parameter_mmin": 0.0,
       "parameter_mmax": 1.0,
       "parameter_modmode": 0,
       "parameter_type": 0,
       "parameter_unitstyle": 1
      }
     },
     "presentation": 1,
     "presentation_rect": [
      182.0,
      74.0,
      48.0,
      48.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-31",
     "maxclass": "newobj",
     "text": "prepend gate",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      890.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-32",
     "maxclass": "live.dial",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      920.0,
      48.0,
      48.0
     ],
     "varname": "Humanizar",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        0.12
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Humanizar",
       "parameter_shortname": "Humanize",
       "parameter_mmin": 0.0,
       "parameter_mmax": 1.0,
       "parameter_modmode": 0,
       "parameter_type": 0,
       "parameter_unitstyle": 1
      }
     },
     "presentation": 1,
     "presentation_rect": [
      240.0,
      74.0,
      48.0,
      48.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-33",
     "maxclass": "newobj",
     "text": "prepend humanizar",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      950.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-34",
     "maxclass": "live.numbox",
     "appearance": 1,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      980.0,
      56.0,
      17.0
     ],
     "varname": "Compassos",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_initial": [
        4
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Compassos",
       "parameter_shortname": "Compassos",
       "parameter_mmin": 1,
       "parameter_mmax": 8,
       "parameter_modmode": 0,
       "parameter_type": 1,
       "parameter_unitstyle": 0
      }
     },
     "presentation": 1,
     "presentation_rect": [
      306.0,
      78.0,
      56.0,
      17.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-35",
     "maxclass": "newobj",
     "text": "prepend compassos",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1010.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-36",
     "maxclass": "live.comment",
     "text": "compassos",
     "numinlets": 1,
     "numoutlets": 0,
     "textjustification": 0,
     "patching_rect": [
      30.0,
      1040.0,
      70.0,
      18.0
     ],
     "presentation": 1,
     "presentation_rect": [
      306.0,
      98.0,
      70.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-37",
     "maxclass": "live.toggle",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1070.0,
      15.0,
      15.0
     ],
     "varname": "Suavizar",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "off",
        "on"
       ],
       "parameter_initial": [
        1
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Suavizar",
       "parameter_shortname": "Suavizar",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      386.0,
      78.0,
      15.0,
      15.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-38",
     "maxclass": "newobj",
     "text": "prepend suavizar",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1100.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-39",
     "maxclass": "live.comment",
     "text": "suavizar",
     "numinlets": 1,
     "numoutlets": 0,
     "textjustification": 0,
     "patching_rect": [
      30.0,
      1130.0,
      70.0,
      18.0
     ],
     "presentation": 1,
     "presentation_rect": [
      406.0,
      78.0,
      70.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-40",
     "maxclass": "live.toggle",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1160.0,
      15.0,
      15.0
     ],
     "varname": "Baixo",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "off",
        "on"
       ],
       "parameter_initial": [
        1
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Baixo",
       "parameter_shortname": "Baixo",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      386.0,
      100.0,
      15.0,
      15.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-41",
     "maxclass": "newobj",
     "text": "prepend baixo",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1190.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-42",
     "maxclass": "live.comment",
     "text": "baixo",
     "numinlets": 1,
     "numoutlets": 0,
     "textjustification": 0,
     "patching_rect": [
      30.0,
      1220.0,
      70.0,
      18.0
     ],
     "presentation": 1,
     "presentation_rect": [
      406.0,
      100.0,
      70.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-43",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1250.0,
      70.0,
      20.0
     ],
     "varname": "Dirup",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "↑",
        "↑"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Dirup",
       "parameter_shortname": "↑",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      470.0,
      78.0,
      34.0,
      20.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-44",
     "maxclass": "newobj",
     "text": "prepend direcao up",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1280.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-45",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1310.0,
      70.0,
      20.0
     ],
     "varname": "Dirdown",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "↓",
        "↓"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Dirdown",
       "parameter_shortname": "↓",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      506.0,
      78.0,
      34.0,
      20.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-46",
     "maxclass": "newobj",
     "text": "prepend direcao down",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1340.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-47",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1370.0,
      70.0,
      20.0
     ],
     "varname": "Dirupdown",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "↕",
        "↕"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Dirupdown",
       "parameter_shortname": "↕",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      542.0,
      78.0,
      34.0,
      20.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-48",
     "maxclass": "newobj",
     "text": "prepend direcao updown",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1400.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-49",
     "maxclass": "live.text",
     "mode": 0,
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "patching_rect": [
      30.0,
      1430.0,
      70.0,
      20.0
     ],
     "varname": "Dirrand",
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_enum": [
        "rnd",
        "rnd"
       ],
       "parameter_initial": [
        0
       ],
       "parameter_initial_enable": 1,
       "parameter_longname": "Dirrand",
       "parameter_shortname": "rnd",
       "parameter_mmax": 1,
       "parameter_modmode": 0,
       "parameter_type": 2
      }
     },
     "presentation": 1,
     "presentation_rect": [
      578.0,
      78.0,
      34.0,
      20.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-50",
     "maxclass": "newobj",
     "text": "prepend direcao rand",
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ],
     "patching_rect": [
      30.0,
      1460.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-51",
     "maxclass": "live.comment",
     "text": "direção",
     "numinlets": 1,
     "numoutlets": 0,
     "textjustification": 0,
     "patching_rect": [
      30.0,
      1490.0,
      70.0,
      18.0
     ],
     "presentation": 1,
     "presentation_rect": [
      470.0,
      100.0,
      70.0,
      16.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-52",
     "maxclass": "newobj",
     "text": "live.thisdevice",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "bang",
      "bang",
      ""
     ],
     "patching_rect": [
      30.0,
      1520.0,
      140.0,
      22.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-53",
     "maxclass": "comment",
     "text": "InstantChord v0.1 — o motor é instantchord.js, ao lado deste arquivo.",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      30.0,
      1550.0,
      420.0,
      20.0
     ],
     "fontsize": 10.0,
     "presentation": 1,
     "presentation_rect": [
      8.0,
      126.0,
      480.0,
      14.0
     ]
    }
   }
  ],
  "lines": [
   {
    "patchline": {
     "destination": [
      "obj-3",
      0
     ],
     "source": [
      "obj-2",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-4",
      0
     ],
     "source": [
      "obj-1",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-3",
      0
     ],
     "source": [
      "obj-4",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-7",
      0
     ],
     "source": [
      "obj-6",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-7",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-9",
      0
     ],
     "source": [
      "obj-8",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-9",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-11",
      0
     ],
     "source": [
      "obj-10",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-13",
      0
     ],
     "source": [
      "obj-12",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-13",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-15",
      0
     ],
     "source": [
      "obj-14",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-15",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-18",
      0
     ],
     "source": [
      "obj-17",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-18",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-20",
      0
     ],
     "source": [
      "obj-1",
      1
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-21",
      0
     ],
     "source": [
      "obj-20",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-16",
      0
     ],
     "source": [
      "obj-21",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-22",
      0
     ],
     "source": [
      "obj-20",
      1
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-6",
      0
     ],
     "source": [
      "obj-22",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-23",
      0
     ],
     "source": [
      "obj-20",
      2
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-19",
      0
     ],
     "source": [
      "obj-23",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-25",
      0
     ],
     "source": [
      "obj-24",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-25",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-27",
      0
     ],
     "source": [
      "obj-26",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-27",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-29",
      0
     ],
     "source": [
      "obj-28",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-29",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-31",
      0
     ],
     "source": [
      "obj-30",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-31",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-33",
      0
     ],
     "source": [
      "obj-32",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-33",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-35",
      0
     ],
     "source": [
      "obj-34",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-35",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-38",
      0
     ],
     "source": [
      "obj-37",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-38",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-41",
      0
     ],
     "source": [
      "obj-40",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-41",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-44",
      0
     ],
     "source": [
      "obj-43",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-44",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-46",
      0
     ],
     "source": [
      "obj-45",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-46",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-48",
      0
     ],
     "source": [
      "obj-47",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-48",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-50",
      0
     ],
     "source": [
      "obj-49",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-50",
      0
     ]
    }
   },
   {
    "patchline": {
     "destination": [
      "obj-1",
      0
     ],
     "source": [
      "obj-52",
      0
     ]
    }
   }
  ],
  "dependency_cache": [],
  "autosave": 0
 }
}