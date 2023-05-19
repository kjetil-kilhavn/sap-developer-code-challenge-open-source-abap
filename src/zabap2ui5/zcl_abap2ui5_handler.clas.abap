class ZCL_ABAP2UI5_HANDLER definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP2UI5_HANDLER IMPLEMENTATION.


  METHOD if_http_extension~handle_request.
    DATA http_headers TYPE tihttpnvp.
    DATA request_parameters TYPE tihttpnvp.

    server->request->get_header_fields( CHANGING fields = http_headers ).
    server->request->get_form_fields( CHANGING fields = request_parameters ).

    z2ui5_cl_http_handler=>client = VALUE #(
       t_header = http_headers
       t_param  = request_parameters
       body     = server->request->get_cdata( ) ).

    DATA(response) = SWITCH #( server->request->get_method( )
       WHEN 'GET'  THEN z2ui5_cl_http_handler=>http_get( )
       WHEN 'POST' THEN z2ui5_cl_http_handler=>http_post( ) ).

    server->response->set_cdata( response ).
    server->response->set_status( code = 200 reason = 'success' ).
  ENDMETHOD.
ENDCLASS.
