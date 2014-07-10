# encoding: utf-8
class StaticController < ApplicationController

    before_action -> { check_session redirect: false }

    # controller für statische seiten. methoden fehlen meistens da die seiten eben statisch sind und daher nur durch die view funktionieren

end
