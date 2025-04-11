import os
import glob
import pathlib

# Get the directory where the script itself is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Configuration
project_name = "jaffle_shop"  # Your SQLMesh project name
seeds_dir = os.path.abspath(os.path.join(script_dir, "../../jaffle-data"))  # Absolute path to seed directory
models_dir = script_dir  # Absolute path to output directory
seeds_schema = "raw"          # Schema for the seeds

def main():
    print(f"Seeds directory: {seeds_dir}")
    print(f"Models directory: {models_dir}")
    
    # Create models directory if it doesn't exist
    os.makedirs(models_dir, exist_ok=True)
    
    # Find all CSV files in the seeds directory
    csv_files = glob.glob(os.path.join(seeds_dir, "*.csv"))
    print(f"Found {len(csv_files)} CSV files")
    
    for csv_path in csv_files:
        filename = os.path.basename(csv_path)
        table_name = os.path.splitext(filename)[0]
        
        # Determine the project root - assuming it's two levels up from models_dir
        project_root = os.path.dirname(os.path.dirname(models_dir))
        
        # Calculate relative path from the project root
        rel_path = os.path.relpath(csv_path, project_root)
        # Normalize path separators to forward slashes for cross-platform compatibility
        rel_path = pathlib.Path(rel_path).as_posix()
        
        # Create model definition with three-level nesting
        model_content = f"""MODEL (
  name {project_name}.{seeds_schema}.{table_name},
  kind SEED (
    path '$root/{rel_path}'
  )
);
"""
        
        # Write the model file
        output_path = os.path.join(models_dir, f"{table_name}_seed.sql")
        with open(output_path, "w") as f:
            f.write(model_content)
        
        print(f"Created seed model for {filename} at {output_path}")

if __name__ == "__main__":
    main()