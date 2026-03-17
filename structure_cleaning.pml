# PyMOL Structure Cleaning Script
# File: structure_cleaning.pml
# Purpose: Automate structure cleaning and visualization for HA-antibody complexes

# ============================================================================
# STRUCTURE CLEANING FUNCTIONS
# ============================================================================

# Function to clean and prepare structure
def clean_structure(structure_name):
    """Clean structure by removing waters, heteroatoms, and preparing for analysis"""
    
    print("Cleaning structure: " + structure_name)
    
    # Remove waters and heteroatoms
    remove solvent
    remove organic
    remove inorganic
    
    # Keep only protein residues
    remove hetatm
    
    # Add hydrogens (optional, for detailed analysis)
    # h_add
    
    # Show cartoon representation
    hide everything
    show cartoon
    
    # Color by chain
    color red, chain A    # HA chain A
    color orange, chain B # HA chain B  
    color blue, chain H   # Heavy chain
    color green, chain L  # Light chain
    
    print("Structure cleaned: " + structure_name)

# ============================================================================
# VISUALIZATION FUNCTIONS  
# ============================================================================

def visualize_complex(pdb_id):
    """Create comprehensive visualization of antibody-antigen complex"""
    
    # Basic setup
    fetch pdb_id
    clean_structure(pdb_id)
    
    # Create selection groups
    select antigen, chain A+B
    select antibody, chain H+L
    select heavy_chain, chain H
    select light_chain, chain L
    
    # Color scheme
    color gray80, antigen
    color marine, heavy_chain  
    color forest, light_chain
    
    # Show interface
    select interface, (antibody within 5 of antigen)
    color red, interface
    show sticks, interface
    
    # Label chains
    label ca and n. ca and resi 1 and chain A, "HA-A"
    label ca and n. ca and resi 1 and chain H, "Heavy"
    label ca and n. ca and resi 1 and chain L, "Light"
    
    # Optimize view
    orient
    zoom
    
    print("Visualization complete for: " + pdb_id)

# ============================================================================
# CDR MAPPING PREPARATION
# ============================================================================

def prepare_cdr_analysis(pdb_id):
    """Prepare structure for CDR region mapping"""
    
    # Load and clean
    fetch pdb_id  
    clean_structure(pdb_id)
    
    # Define approximate CDR regions (Kabat numbering)
    # These will need adjustment based on actual sequence numbering
    
    # Heavy chain CDRs
    select CDR_H1_approx, chain H and resi 26-32
    select CDR_H2_approx, chain H and resi 52-56  
    select CDR_H3_approx, chain H and resi 95-102
    
    # Light chain CDRs
    select CDR_L1_approx, chain L and resi 24-34
    select CDR_L2_approx, chain L and resi 50-56
    select CDR_L3_approx, chain L and resi 89-97
    
    # Color CDRs distinctly
    color orange, CDR_H1_approx
    color yellow, CDR_H2_approx
    color magenta, CDR_H3_approx
    color cyan, CDR_L1_approx
    color green, CDR_L2_approx  
    color pink, CDR_L3_approx
    
    # Show CDRs as sticks
    show sticks, CDR_H1_approx+CDR_H2_approx+CDR_H3_approx+CDR_L1_approx+CDR_L2_approx+CDR_L3_approx
    
    # Create interface view
    select cdr_interface, (CDR_H1_approx+CDR_H2_approx+CDR_H3_approx+CDR_L1_approx+CDR_L2_approx+CDR_L3_approx) within 8 of (chain A+B)
    
    print("CDR analysis preparation complete")

# ============================================================================
# AUTOMATED WORKFLOW FOR 5XKU
# ============================================================================

def analyze_5xku():
    """Complete analysis workflow for 5XKU structure"""
    
    print("Starting 5XKU analysis workflow...")
    
    # Step 1: Load and clean
    fetch 5XKU
    clean_structure("5XKU")
    
    # Step 2: Chain analysis
    select ha_chains, chain A+B
    select ab_chains, chain H+L
    
    # Count residues per chain  
    count_residues("Chain A", "chain A")
    count_residues("Chain B", "chain B")
    count_residues("Chain H", "chain H") 
    count_residues("Chain L", "chain L")
    
    # Step 3: Interface analysis
    select interface_5A, (ab_chains within 5 of ha_chains)
    select interface_3A, (ab_chains within 3 of ha_chains)
    
    show sticks, interface_5A
    color red, interface_5A
    
    # Step 4: CDR preparation
    prepare_cdr_analysis("5XKU")
    
    # Step 5: Multiple views
    create_views_5xku()
    
    print("5XKU analysis complete!")

def count_residues(label, selection):
    """Count residues in a selection"""
    select temp_sel, selection and polymer
    print(label + " residue count: " + str(cmd.count_atoms("temp_sel and name ca")))
    delete temp_sel

def create_views_5xku():
    """Create multiple views for 5XKU documentation"""
    
    # View 1: Overall complex
    set_view(\
        0.999,    0.000,    0.000,\
        0.000,    1.000,    0.000,\
        0.000,    0.000,    1.000,\
        0.000,    0.000,  -50.000,\
        0.000,    0.000,    0.000,\
      100.000, -100.000,   20.000)
    
    png ../results/5XKU_overview.png, width=1200, height=900, dpi=300, ray=1
    
    # View 2: Interface close-up
    orient interface_5A
    zoom interface_5A, 10
    png ../results/5XKU_interface.png, width=1200, height=900, dpi=300, ray=1
    
    # View 3: CDR regions
    orient CDR_H1_approx+CDR_H2_approx+CDR_H3_approx
    zoom CDR_H1_approx+CDR_H2_approx+CDR_H3_approx, 8
    png ../results/5XKU_CDRs.png, width=1200, height=900, dpi=300, ray=1
    
    print("Views saved to ../results/")

# ============================================================================
# BATCH PROCESSING ALL STRUCTURES
# ============================================================================

def process_all_structures():
    """Process all target structures"""
    
    structures = ["3LZG", "4O5N", "5XKU"]
    
    for pdb_id in structures:
        print("Processing: " + pdb_id)
        
        # Clear previous structure
        delete all
        
        # Load and process
        fetch pdb_id
        clean_structure(pdb_id)
        
        # Save cleaned structure  
        save ../data/processed/ + pdb_id + _clean.pdb
        
        # Create overview image
        orient
        png ../results/ + pdb_id + _overview.png, width=800, height=600, dpi=300, ray=1
        
        print("Completed: " + pdb_id)
    
    print("All structures processed!")

# ============================================================================
# MAIN EXECUTION
# ============================================================================

# Uncomment the function you want to run:

# For single structure analysis:
# analyze_5xku()

# For batch processing:  
# process_all_structures()

# For custom analysis:
# fetch 5XKU
# prepare_cdr_analysis("5XKU")

print("PyMOL cleaning script loaded. Run analyze_5xku() to start analysis.")
