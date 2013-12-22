class BITHockeyManagerLauncher

  BITCrashManagerStatusDisabled = 0
  BITCrashManagerStatusAlwaysAsk = 1
  BITCrashManagerStatusAutoSend = 2
  
  def start(&block)
    return unless hockeyapp_enabled?
    (@plist = NSBundle.mainBundle.objectForInfoDictionaryKey('HockeySDK')) && (@plist = @plist.first)
    return unless @plist
    BITHockeyManager.sharedHockeyManager.configureWithBetaIdentifier(@plist['beta_id'], liveIdentifier:@plist['live_id'], delegate:self)
    BITHockeyManager.sharedHockeyManager.updateManager.delegate = self

    BITHockeyManager.sharedHockeyManager.crashManager.crashManagerStatus = BITCrashManagerStatusAutoSend
    block.call if !block.nil?
    BITHockeyManager.sharedHockeyManager.startManager
    true
  end

  def authenticate
    return unless hockeyapp_enabled?
    BITHockeyManager.sharedHockeyManager.authenticator.authenticateInstallation
  end

  private

  def hockeyapp_enabled?
    Object.const_defined?('BITHockeyManager') && !UIDevice.currentDevice.model.include?('Simulator')
  end
end
