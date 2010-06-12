
#
# testing ruote
#
# Tue Apr 20 12:32:44 JST 2010
#

require File.join(File.dirname(__FILE__), 'base')

require 'ruote/part/storage_participant'


class FtEngineTest < Test::Unit::TestCase
  include FunctionalBase

  def test_workitem

    pdef = Ruote.process_definition :name => 'my process' do
      alpha
    end

    sp = @engine.register_participant :alpha, Ruote::StorageParticipant

    #noisy

    wfid = @engine.launch(pdef)

    wait_for(:alpha)

    assert_equal Ruote::Workitem, @engine.workitem("0_0!!#{wfid}").class
  end

  class MyParticipant
    include Ruote::LocalParticipant
    def initialize (opts)
    end
    def consume (workitem)
      sleep rand * 2
      reply_to_engine(workitem)
    end
  end

  def test_wait_for_empty

    pdef = Ruote.process_definition :name => 'my process' do
      alpha
    end

    @engine.register_participant :alpha, MyParticipant

    4.times do
      @engine.launch(pdef)
    end

    #noisy

    @engine.wait_for(:empty)

    assert_equal [], @engine.processes
  end
end

