//
//  PatientTableViewController.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/5/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import UIKit

class PatientTableViewController: UITableViewController {

    // MARK: [Properties]
    fileprivate let NUM_SPORTS : Int = 10
    
    fileprivate var _baseball   = [Patient]()
    fileprivate var _basketball = [Patient]()
    fileprivate var _football   = [Patient]()
    fileprivate var _hockey     = [Patient]()
    fileprivate var _lacrosse   = [Patient]()
    fileprivate var _soccer     = [Patient]()
    fileprivate var _swimming   = [Patient]()
    fileprivate var _tennis     = [Patient]()
    fileprivate var _track      = [Patient]()
    fileprivate var _wrestling  = [Patient]()
    
    var patients = [Patient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //loadSamplePatients()
        
        // [Load any saved data]
        if let savedPatients = loadPatients(){
            patients += savedPatients
            
            for patient in patients {
                addPatient(patient)
            }
        }else{
            // load sample data
            loadSamplePatients()
        }
    }
    
    func loadSamplePatients(){
        let photo1 = UIImage(named:"patient1")!
        let patient1 = Patient(firstName: "Justin", lastName: "Dambra", photo: photo1, rating: 4, sport:0)!
        
        let photo2 = UIImage(named:"patient2")!
        let patient2 = Patient(firstName: "Brian", lastName: "Panda", photo: photo2, rating: 2, sport:1)!
        
        let photo3 = UIImage(named:"patient3")!
        let patient3 = Patient(firstName: "Drake", lastName: "Low", photo: photo3, rating: 5, sport:2)!
        
        _baseball.append(patient1)
        _basketball.append(patient2)
        _football.append(patient3)
    }
    
    func numberOfPopulatedArrays()->Int{
        var tNumArrays = 0;
        
        if(_baseball.count > 0){
            tNumArrays+=1;
        }
        
        return tNumArrays;
    }
    
    func addArrayCount( _ pArray:[Patient]?) -> Int{
        if(pArray!.count > 0){
            return 1;
        }
        
        return 0;
    }

    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Section Header Title
        return AppManager.getSportString(section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return NUM_SPORTS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return getCorrectSport(section)!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientTableViewCell";
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientTableViewCell
        
        // [Set Patient]
        let patient = getCorrectSport(indexPath.section)![indexPath.row];
        
        cell.fullName.text = patient.lastName + ", " + patient.firstName;
        cell.photoImageView.image = patient.photo;
        cell.ratingControl.rating = patient.rating;

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removePatient(indexPath.section, index:indexPath.row)
            savePatients()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowDetail"){
            let patientDetailViewController = segue.destination as! PatientViewController;
            
            if let selectedPatientCell = sender as? PatientTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPatientCell)!
                
                // [Selected Patient Data]
                let selectedPatient = getCorrectSport(indexPath.section)![indexPath.row]
                patientDetailViewController.patient = selectedPatient;
            }
            
            print("Editing existing patient");
        }else if(segue.identifier == "AddItem"){
            // print("Adding new patient.");
        }
    }
    
    // [Moving To TableViewController]
    @IBAction func unwindToPatientList(_ sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? PatientViewController, let patient = sourceViewController.patient{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // [Update Existing Patient If Sport Did Not Change]
                
                // patients[selectedIndexPath.row] = patient;
                
                // getCorrectSport(selectedIndexPath.section)[selectedIndexPath.row] = patient
                tableView.reloadRows(at: [selectedIndexPath], with: .none);
                
            }else{
                // [Adds New Patient at Correct Row And Section]
                addPatient(patient);
                
                // [Finds Correct Index To Place Patient In Table]
                var count:Int = 0;
                let tSportArray:[Patient] = getCorrectSport(patient.sport.rawValue)!;
                for athlete in tSportArray{
                    if(patient == athlete){
                        break;
                    }
                    count+=1;
                }
                
                let newIndexPath = IndexPath(row: count, section: patient.sport.rawValue);
                tableView.insertRows(at: [newIndexPath], with: .bottom);
            }

            // [Save Patients]
            savePatients();
        }
    }
    
    // MARK: Helper Functions
    
    // [Return Correct Array] DO NOT CALL WHEN TRYING TO CHANGE/EDIT DATA
    func getCorrectSport(_ section:Int) ->[Patient]? {
        switch(section){
        case Patient.Sport.baseball.rawValue:
            return _baseball
        case Patient.Sport.basketball.rawValue:
            return _basketball
        case Patient.Sport.football.rawValue:
            return _football
        case Patient.Sport.hockey.rawValue:
            return _hockey
        case Patient.Sport.lacrosse.rawValue:
            return _lacrosse
        case Patient.Sport.soccer.rawValue:
            return _soccer
        case Patient.Sport.swimming.rawValue:
            return _swimming
        case Patient.Sport.tennis.rawValue:
            return _tennis
        case Patient.Sport.track.rawValue:
            return _track
        case Patient.Sport.wrestling.rawValue:
            return _wrestling
        default:
            // [THIS SHOULD NEVER HAPPEN]
            print("[PatientTableViewController] trying to access an inexistant sport")
            return nil;
        }
    }
    
    // [Add Patient To Correct Array]
    func addPatient(_ patient:Patient){
        switch(patient.sport.rawValue){
        case Patient.Sport.baseball.rawValue:
            _baseball.append(patient)
            _baseball = _baseball.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.basketball.rawValue:
            _basketball.append(patient)
            _basketball = _basketball.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.football.rawValue:
            _football.append(patient)
            _football = _football.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.hockey.rawValue:
            _hockey.append(patient)
            _hockey = _hockey.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.lacrosse.rawValue:
            _lacrosse.append(patient)
            _lacrosse = _lacrosse.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.soccer.rawValue:
            _soccer.append(patient)
            _soccer = _soccer.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.swimming.rawValue:
            _swimming.append(patient)
            _swimming = _swimming.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.tennis.rawValue:
            _tennis.append(patient)
            _tennis = _tennis.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.track.rawValue:
            _track.append(patient)
            _track = _track.sorted(by: { $0.lastName < $1.lastName })
        case Patient.Sport.wrestling.rawValue:
            _wrestling.append(patient)
            _wrestling = _wrestling.sorted(by: { $0.lastName < $1.lastName })
        default:
            print("[PatientTableViewController] (addPatient) ERROR. Should Not Get Here")
        }
    }
    
    // [Remove Patient From Array]
    func removePatient(_ section:Int, index:Int){
        switch(section){
        case Patient.Sport.baseball.rawValue:
            _baseball.remove(at: index)
        case Patient.Sport.basketball.rawValue:
            _basketball.remove(at: index)
        case Patient.Sport.football.rawValue:
            _football.remove(at: index)
        case Patient.Sport.hockey.rawValue:
            _hockey.remove(at: index)
        case Patient.Sport.lacrosse.rawValue:
            _lacrosse.remove(at: index)
        case Patient.Sport.soccer.rawValue:
            _soccer.remove(at: index)
        case Patient.Sport.swimming.rawValue:
            _swimming.remove(at: index)
        case Patient.Sport.tennis.rawValue:
            _tennis.remove(at: index)
        case Patient.Sport.track.rawValue:
            _track.remove(at: index)
        case Patient.Sport.wrestling.rawValue:
            _wrestling.remove(at: index)
        default:
            print("[PatientTableViewController] (removePatient) ERROR. Should Not Get Here")
        }
    }
    
    // [Saves Patient Into Final Array]
    func savePatient(_ pSport:[Patient]?) {
        for patient in pSport! {
            patients.append(patient)
        }
    }
    
    // MARK: [NSCoding]
    func savePatients(){
        patients.removeAll()
        
        // Saves All Patients Into One Array
        savePatient(_baseball);
        savePatient(_basketball);
        savePatient(_football);
        savePatient(_hockey);
        savePatient(_lacrosse);
        savePatient(_soccer);
        savePatient(_swimming);
        savePatient(_tennis);
        savePatient(_track);
        savePatient(_wrestling);
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(patients, toFile: Patient.ArchiveURL.path);
        
        if !isSuccessfulSave{
            print("Failed to save patient");
        }
    }
    
    func loadPatients() ->[Patient]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Patient.ArchiveURL.path) as? [Patient];
    }
}
