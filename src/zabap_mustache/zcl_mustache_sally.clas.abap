CLASS zcl_mustache_sally DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_band_member,
        name       TYPE string,
        instrument TYPE string,
        years      TYPE n LENGTH 1,
      END OF ty_band_member,
      ty_band_members TYPE STANDARD TABLE OF ty_band_member WITH EMPTY KEY.

    TYPES:
      BEGIN OF marching_band,
        name    TYPE string,
        founded TYPE datum,
        members TYPE ty_band_members,
      END OF marching_band.

    DATA our_band TYPE marching_band.
ENDCLASS.



CLASS zcl_mustache_sally IMPLEMENTATION.

  METHOD constructor.
    our_band-name = |Bogafjell skolekorps|.
    our_band-founded = '20051005'.
    our_band-members = VALUE #(
        ( name = 'Oda Kilhavn'       instrument = 'kornett'  years = 5 )
        ( name = 'Sofia Lambrigtsen' instrument = 'slagverk' years = 4 )
        ( name = 'Helene Hiim Boga'  instrument = 'baryton'  years = 4 )
        ( name = 'Solveig Kilhavn'   instrument = 'slagverk' years = 4 )
        ( name = 'Martha Keretsman'  instrument = 'kornett'  years = 3 )
        ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    CONSTANTS nl TYPE abap_char1 VALUE cl_abap_char_utilities=>newline.
    DATA band_page TYPE REF TO zcl_mustache.

    TRY.
        band_page = zcl_mustache=>create(
                      iv_template = `{{name}} ble stiftet {{founded}}.` && nl
                                 && nl && `Medlemmene er:` && nl
                                 && `{{#members}}`
                                 && `* {{name}} som spiller {{instrument}} og har vært med i {{years}} år` && nl
                                 && `{{/members}}`).
        out->write_text( band_page->render( our_band ) ).
      CATCH zcx_mustache_error INTO DATA(mustache_error).
        out->write( mustache_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
