import pandas as pd
import great_expectations as gx
from pathlib import Path
from typing import Dict, Any, Optional


class DataValidation:
    """
    Centralized data validation using Great Expectations.
    Handles dataset validation against defined expectations for SINAN Dengue data.
    """

    def __init__(self, suite_name: str = "sinan_raw_suite", checkpoint_name: str = "sinan_raw_checkpoint"):
        """
        Initialize the DataValidation handler.

        Args:
            suite_name: Name of the expectation suite
            checkpoint_name: Name of the checkpoint
        """
        self.suite_name = suite_name
        self.checkpoint_name = checkpoint_name
        self.result = None
        self.context = None

    def _initialize_context(self):
        """Initialize Great Expectations context from project directory."""
        try:
            self.context = gx.get_context(mode="file", project_root_dir="/app/gx")
            print("✓ GX context initialized from /app/gx")
        except Exception as e:
            print(f"Warning initializing context from /app/gx: {e}")
            try:
                self.context = gx.get_context()
                print("✓ GX context initialized (ephemeral)")
            except Exception as e2:
                print(f"Error initializing ephemeral context: {e2}")
                raise

    def validate(self, df: pd.DataFrame) -> Dict[str, Any]:
        """
        Run validation on the provided dataframe using Great Expectations.

        Args:
            df: DataFrame to validate

        Returns:
            Dictionary containing validation results
        """
        try:
            print(f"Starting GX validation with {len(df)} rows")
            
            self._initialize_context()

            datasource_name = "sinan_pandas_datasource"
            try:
                datasource = self.context.data_sources.add_pandas(name=datasource_name)
                print(f"✓ Created datasource: {datasource_name}")
            except Exception as e:
                print(f"Datasource might already exist: {e}")
                datasource = self.context.data_sources.get(datasource_name)

            # Create asset
            asset_name = "sinan_data_asset"
            try:
                asset = datasource.add_dataframe_asset(name=asset_name)
                print(f"✓ Created asset: {asset_name}")
            except Exception as e:
                print(f"Asset might already exist: {e}")
                asset = datasource.get_asset(asset_name)

            # Build batch definition
            batch_definition_name = "sinan_batch_def"
            try:
                batch_def = asset.add_batch_definition(name=batch_definition_name)
                print(f"✓ Created batch definition: {batch_definition_name}")
            except Exception as e:
                print(f"Batch definition might already exist: {e}")
                batch_def = asset.get_batch_definition(batch_definition_name)

            # Create expectation suite
            expectation_suite = gx.ExpectationSuite(name=self.suite_name)
            try:
                expectation_suite = self.context.suites.add(expectation_suite)
            except Exception:
                expectation_suite = self.context.suites.get(self.suite_name)

            print(f"✓ Created expectation suite: {self.suite_name}")

            expectation_1 = gx.expectations.ExpectColumnValuesToNotBeNull(
                column="TP_NOT"
            )
            expectation_suite.add_expectation(expectation_1)
            print("✓ Added expectation: TP_NOT values must not be null")

            expectation_2 = gx.expectations.ExpectColumnValuesToBeBetween(
                column="NU_IDADE_N",
                min_value=0,
                max_value=120
            )
            expectation_suite.add_expectation(expectation_2)
            print("✓ Added expectation: NU_IDADE_N between 0 and 120")

            expectation_3 = gx.expectations.ExpectColumnValuesToBeInSet(
                column="CS_SEXO",
                value_set=["F", "M", ""]
            )
            expectation_suite.add_expectation(expectation_3)
            print("✓ Added expectation: CS_SEXO in ['F', 'M', '']")

            validation_def = gx.ValidationDefinition(
                data=batch_def,
                suite=expectation_suite,
                name="sinan_validations"
            )
            
            try:
                self.context.validation_definitions.add(validation_def)
            except Exception:
                pass
            
            print("✓ Created validation definition")

            # Create checkpoint with actions
            action_list = [
                gx.checkpoint.UpdateDataDocsAction(name="update_data_docs")
            ]
            
            checkpoint = gx.Checkpoint(
                name=self.checkpoint_name,
                validation_definitions=[validation_def],
                actions=action_list,
                result_format={"result_format": "COMPLETE"}
            )
            
            try:
                self.context.checkpoints.add(checkpoint)
            except Exception:
                pass
            print("✓ Created checkpoint")

            # Run checkpoint
            run_id = gx.RunIdentifier(run_name="sinan_validation_run")
            results = checkpoint.run(batch_parameters={"dataframe": df})

            return {
                "success": results.success,
                "message": "Validation completed successfully",
                "results": results.to_json_dict() if hasattr(results, 'to_json_dict') else str(results)
            }

        except Exception as e:
            print(f"Error during validation: {str(e)}")
            import traceback
            traceback.print_exc()
            return {
                "success": False,
                "error": str(e),
                "message": "Validation failed"
            }

    def get_result(self) -> Optional[Dict[str, Any]]:
        """
        Get the validation result.

        Returns:
            Validation result dictionary or None if not yet validated
        """
        return self.result

