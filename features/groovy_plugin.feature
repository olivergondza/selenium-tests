Feature: Executing groovy scripts

  @needs_preinstalled_sw
  Scenario: Run groovy script
    Given I have installed the "groovy" plugin
    And a job
    When I set groovy build step "Execute Groovy script"
    And I set groovy script
        """
           println('hello world')
        """
    And I save the job
    And I build the job
    Then the build should succeed
    And I should see console output matching "hello world"

  Scenario: Run system groovy script as a command
    Given I have installed the "groovy" plugin
    When I create a job named "system-groovy-test"
    And I set groovy build step "Execute system Groovy script"
    And I set groovy script
        """
            j = jenkins.model.Jenkins.instance;
            println 'this is a job ' + j.getItem('system-groovy-test').displayName
        """
    And I save the job
    And I build the job
    Then the build should succeed
    And I should see console output matching "this is a job system-groovy-test"

  @needs_preinstalled_sw
  Scenario: Run groovy script from a file
    Given I have installed the "groovy" plugin
    And a job
    When I add a shell build step "echo println \'hello\' > hello.groovy"
    And I set groovy build step "Execute Groovy script"
    And I set groovy script from file "hello.groovy"
    And I save the job
    And I build the job
    Then the build should succeed
    And I should see console output matching "hello"

  Scenario: Add and run auto-installed Groovy
    Given I have installed the "groovy" plugin
    And a job
    And I have Groovy "2.1.1" auto-installation named "groovy_2.1.1" configured
    When I configure the job
    And I set groovy build step "Execute Groovy script"
    And I select groovy named "groovy_2.1.1"
    And I set groovy script
        """
            println 'Groovy version: ' + groovy.lang.GroovySystem.getVersion()
        """
    And I save the job
    And I build the job
    Then the build should succeed
    And I should see console output matching "Unpacking http://dist.groovy.codehaus.org/distributions/groovy-binary-2.1.1.zip"
    And I should see console output matching "Groovy version: 2.1.1"

  @needs_preinstalled_sw
  Scenario: Add and run auto-installed Groovy
    Given I have installed the "groovy" plugin
    And fake Groovy installation at "/tmp/fake-groovy"
    And a job
    And I have Groovy "local_groovy_2.1.1" installed in "/tmp/fake-groovy" configured
    When I configure the job
    And I set groovy build step "Execute Groovy script"
    And I select groovy named "local_groovy_2.1.1"
    And I set groovy script
        """
            println 'Groovy version: ' + groovy.lang.GroovySystem.getVersion()
        """
    And I save the job
    And I build the job
    Then the build should succeed
    And I should see console output matching "fake groovy at /tmp/fake-groovy/bin/groovy"
